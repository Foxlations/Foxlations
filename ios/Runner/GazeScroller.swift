import ARKit
import CoreMotion
import Foundation
import simd

/// User-tunable gaze parameters, mirrored from the Dart settings. All fields have
/// safe defaults so an unconfigured scroller still behaves.
struct GazeSettings {
    enum Mode: String {
        case eyesOnly
        case headOnly
        case combined
    }

    /// Which signal(s) drive scrolling.
    var mode: Mode = .combined
    /// How far past the calibrated neutral the gaze/head must move to count as a
    /// deliberate look up/down (normalized units; eye blendshapes are 0…1, head
    /// pitch is radians — the threshold is compared against whichever signal the
    /// mode selects). Since 5-point calibration normalizes the signal to the
    /// user's own range, this is the dead-zone boundary (0…1): ~0.6 means the
    /// middle 3/5 of the screen is a dead zone and only the outer fifths scroll.
    var threshold: Double = 0.8
    /// How long the look must be held before scrolling starts, in milliseconds.
    /// Guards against normal reading eye movement triggering a scroll.
    var dwellMs: Int = 300
    /// Low-pass smoothing factor (0…1). Higher = snappier but noisier.
    var smoothing: Double = 0.25
    /// Use ARKit's own gaze estimate (`lookAtPoint`) instead of the expression
    /// blendshapes for the eye signal. Head-independent and smoother.
    var useLookAt: Bool = true
    /// Project the gaze ray onto the device's screen plane for a geometric on-screen
    /// gaze point (uses the eye positions + the device pose from world tracking),
    /// instead of the raw lookAtPoint magnitudes. More physically accurate; the
    /// exact scale/sign residual is absorbed by calibration. Falls back to lookAtPoint
    /// when the device pose isn't available.
    var useGeometric: Bool = true
}

/// A scroll intent emitted to the bridge layer. `intensity` (0…1) scales speed.
struct GazeDecision: Equatable {
    enum Direction: String {
        case up
        case down
        case none
    }

    var direction: Direction
    var intensity: Double
}

/// Face-tracking gaze engine. Owns an `ARSession` with `ARFaceTrackingConfiguration`
/// (no camera preview) and turns face-anchor updates into `GazeDecision`s.
///
/// Deliberately decoupled from Flutter and from any UI: it emits decisions through
/// `onDecision` and can be driven with synthetic input via `process(vertical:pitch:)`
/// for unit tests, so no live camera is needed to test the thresholds/dwell/smoothing.
final class GazeScroller: NSObject, ARSessionDelegate {
    /// True only on devices with a TrueDepth camera (Face ID / A12+). The whole
    /// feature is hidden when this is false.
    static var isSupported: Bool { ARFaceTrackingConfiguration.isSupported }

    var settings = GazeSettings()

    /// Emitted on the main thread whenever the scroll intent meaningfully changes.
    var onDecision: ((GazeDecision) -> Void)?

    private let session = ARSession()
    private(set) var isRunning = false

    // ── device-motion compensation (CoreMotion) ───────────────────────────────
    // World tracking keeps the head signal gravity-referenced for slow movement;
    // this gyro feed gates the fast/jerky movement that even world tracking can't
    // absorb cleanly — while the phone is being swung around, the face-relative
    // signal is noise, so we suppress scrolling rather than act on it.
    private let motion = CMMotionManager()
    private let motionQueue = OperationQueue()
    private var deviceAngularSpeed = 0.0 // rad/s, |rotationRate|
    /// Above this angular speed the device is considered "being moved", and gaze
    /// decisions are held. ~1.2 rad/s ≈ 69°/s — well above holding the phone to read.
    private static let motionGate = 1.2

    // ── filtered signals ──────────────────────────────────────────────────────
    // vertical: averaged eye-look, +down / -up. pitch: head nod, +down / -up.
    private var filteredVertical = 0.0
    private var filteredHorizontal = 0.0
    private var filteredPitch = 0.0
    private var hasSample = false

    /// Live 2D gaze vector relative to the calibrated centre (x: +right, y: +down),
    /// for the calibration UI's dot. Streamed only while [previewing].
    var onPreview: ((Double, Double, Double, Double, Double) -> Void)?
    var previewing = false

    // ── calibration baselines (neutral gaze + head) ───────────────────────────
    private var baseVertical = 0.0
    private var baseHorizontal = 0.0
    private var basePitch = 0.0

    // ── calibrated range (5-point calibration) ─────────────────────────────────
    // Signed spans from the neutral centre to each screen extreme, so both the
    // sign (handedness — corrects the front-camera mirror) and the magnitude
    // (gain — corrects "look way past the screen" and the weaker eyeLookUp) come
    // from where the user actually looked. Defaults approximate a typical range so
    // an uncalibrated engine still behaves. `pos` = down/right, `neg` = up/left.
    private var vDownSpan = 0.45     // eye vertical, centre → bottom (expected > 0)
    private var vUpSpan = -0.35      // eye vertical, centre → top    (expected < 0)
    private var hRightSpan = 0.35    // eye horizontal, centre → right
    private var hLeftSpan = -0.35    // eye horizontal, centre → left
    // Head pitch is normalized to a comfortable deliberate-nod range, not the tiny
    // incidental head movement captured while the eyes scan the targets, so
    // head-only mode keeps needing a real tilt rather than becoming twitchy.
    private var pDownSpan = 0.25     // head pitch, centre → bottom (radians)
    private var pUpSpan = -0.22      // head pitch, centre → top

    private var calibrating = false
    private var adoptOnFinish = true
    private var calibrationSamples: [(Double, Double, Double)] = []
    private var onCalibrated: ((Double, Double, Double) -> Void)?

    // ── dwell + emit throttling ────────────────────────────────────────────────
    private var pendingDirection: GazeDecision.Direction = .none
    private var dwellStart = 0.0
    private var lastEmitted = GazeDecision(direction: .none, intensity: 0)

    // MARK: - Lifecycle

    /// Start face tracking. No-op if unsupported or already running.
    func start() {
        guard GazeScroller.isSupported, !isRunning else { return }
        let config = ARFaceTrackingConfiguration()
        // Head pose comes from the TrueDepth IR depth mesh (the Face ID hardware),
        // so HEAD-tilt tracking works even in the dark. EYE-gaze blendshapes need
        // visible light on the eyes, though, and go flat in darkness — low-light
        // users should switch to head-tilt mode. Light estimation is only for AR
        // scene rendering (unused), so it stays off.
        config.isLightEstimationEnabled = false
        if #available(iOS 13.0, *) {
            config.maximumNumberOfTrackedFaces = 1
            // Motion compensation: with world tracking, the face anchor's orientation
            // is reported in a fixed, gravity-aligned world frame, so moving/tilting
            // the PHONE no longer registers as a head tilt — only moving the head does.
            // Only on devices that support running face + world tracking together;
            // elsewhere it falls back to the camera-relative behaviour.
            if ARFaceTrackingConfiguration.supportsWorldTracking {
                config.isWorldTrackingEnabled = true
            }
        }
        session.delegate = self
        session.run(config, options: [.resetTracking, .removeExistingAnchors])
        isRunning = true
        startMotion()
    }

    /// Feed the gyro so [evaluate] can gate scrolling while the device is being moved.
    private func startMotion() {
        guard motion.isDeviceMotionAvailable, !motion.isDeviceMotionActive else { return }
        motion.deviceMotionUpdateInterval = 1.0 / 30.0
        motion.startDeviceMotionUpdates(to: motionQueue) { [weak self] dm, _ in
            guard let self, let r = dm?.rotationRate else { return }
            self.deviceAngularSpeed = (r.x * r.x + r.y * r.y + r.z * r.z).squareRoot()
        }
    }

    /// Pause tracking (backgrounding, reader dismissed) and stop any scrolling.
    func pause() {
        guard isRunning else { return }
        session.pause()
        isRunning = false
        if motion.isDeviceMotionActive { motion.stopDeviceMotionUpdates() }
        deviceAngularSpeed = 0
        resetSignals()
        emit(GazeDecision(direction: .none, intensity: 0))
    }

    /// Fully tear down; the session is released with the instance.
    func stop() {
        pause()
        session.delegate = nil
    }

    private func resetSignals() {
        hasSample = false
        pendingDirection = .none
    }

    // MARK: - Calibration

    /// Sample the user's neutral gaze + head pose for `durationMs`, then adopt the
    /// average as the baseline that thresholds are measured against.
    /// Start face tracking a saved gaze baseline (v, h, p) so calibration
    /// persists across sessions.
    func applyBaseline(_ v: Double, _ h: Double, _ p: Double) {
        baseVertical = v
        baseHorizontal = h
        basePitch = p
    }

    /// Adopt a full 5-point calibration: the neutral centre plus the signed spans
    /// out to each screen extreme. Spans that came back too small to be a real look
    /// (user barely moved, or a flat blendshape) fall back to the safe default so a
    /// bad sample can't make an axis hypersensitive.
    func applyModel(baseV: Double, baseH: Double, baseP: Double,
                    vDown: Double, vUp: Double, hRight: Double, hLeft: Double,
                    pDown: Double, pUp: Double) {
        baseVertical = baseV
        baseHorizontal = baseH
        basePitch = baseP
        vDownSpan = span(vDown, default: 0.45, min: 0.10)
        vUpSpan = span(vUp, default: -0.35, min: 0.10)
        hRightSpan = span(hRight, default: 0.35, min: 0.10)
        hLeftSpan = span(hLeft, default: -0.35, min: 0.10)
        // Higher floor on pitch: an incidental nod during eye calibration must not
        // make head-only mode hypersensitive.
        pDownSpan = span(pDown, default: 0.25, min: 0.18)
        pUpSpan = span(pUp, default: -0.22, min: 0.16)
    }

    /// Clamp a measured span to at least `min` magnitude (keeping its sign); if it
    /// is effectively zero, use `default` (which carries the expected sign).
    private func span(_ measured: Double, default def: Double, min minMag: Double) -> Double {
        if abs(measured) < 0.02 { return def }
        let sign = measured < 0 ? -1.0 : 1.0
        return sign * max(abs(measured), minMag)
    }

    /// Map a signed delta-from-centre into normalized range units: +1 at the
    /// positive extreme (down/right), -1 at the negative extreme (up/left). The
    /// span signs encode handedness, so this is mirror-correct by construction.
    private func normed(_ delta: Double, pos: Double, neg: Double) -> Double {
        if pos != 0, delta * pos >= 0 {
            return min(1.6, delta / pos)
        }
        if neg != 0, delta * neg > 0 {
            return -min(1.6, delta / neg)
        }
        return 0
    }

    /// Toggle the live 2D preview stream (for the calibration dot).
    func setPreview(_ on: Bool) {
        previewing = on
    }

    /// Sample the gaze/head signal for `durationMs` and return the average. When
    /// `adopt` is true (single-point calibration) the average also becomes the new
    /// neutral baseline; multi-point calibration passes `adopt: false` so sampling
    /// a corner never shifts the engine's idea of centre — the five points are
    /// combined into one model (centre + spans) and applied once, via `applyModel`.
    func calibrate(durationMs: Int, adopt: Bool = true,
                   completion: @escaping (Double, Double, Double) -> Void) {
        calibrationSamples.removeAll()
        onCalibrated = completion
        adoptOnFinish = adopt
        calibrating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(durationMs)) { [weak self] in
            self?.finishCalibration()
        }
    }

    private func finishCalibration() {
        calibrating = false
        var v = baseVertical, h = baseHorizontal, p = basePitch
        if !calibrationSamples.isEmpty {
            let count = Double(calibrationSamples.count)
            v = calibrationSamples.reduce(0) { $0 + $1.0 } / count
            h = calibrationSamples.reduce(0) { $0 + $1.1 } / count
            p = calibrationSamples.reduce(0) { $0 + $1.2 } / count
            if adoptOnFinish {
                baseVertical = v
                baseHorizontal = h
                basePitch = p
            }
        }
        let done = onCalibrated
        onCalibrated = nil
        done?(v, h, p)
    }

    // MARK: - ARSessionDelegate

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let face = anchors.compactMap({ $0 as? ARFaceAnchor }).first else { return }
        ingest(face)
    }

    private func ingest(_ face: ARFaceAnchor) {
        let shapes = face.blendShapes
        func value(_ key: ARFaceAnchor.BlendShapeLocation) -> Double {
            shapes[key]?.doubleValue ?? 0
        }
        // Average both eyes so a single eye's noise doesn't dominate; down positive.
        let down = (value(.eyeLookDownLeft) + value(.eyeLookDownRight)) / 2.0
        let up = (value(.eyeLookUpLeft) + value(.eyeLookUpRight)) / 2.0
        // Horizontal: looking right = left eye in + right eye out; left = the mirror.
        let right = (value(.eyeLookInLeft) + value(.eyeLookOutRight)) / 2.0
        let left = (value(.eyeLookOutLeft) + value(.eyeLookInRight)) / 2.0
        let blendV = down - up, blendH = right - left
        // Apple's own gaze estimate (face-space point the eyes are aimed at).
        // Head-independent and smoother than the expression blendshapes; the sign
        // and scale are absorbed by calibration.
        let look = face.lookAtPoint
        let lookV = Double(-look.y), lookH = Double(look.x)
        let useLA = settings.useLookAt
        var vSig = useLA ? lookV : blendV
        var hSig = useLA ? lookH : blendH
        // Prefer the geometric on-screen gaze point when available — it's a real
        // projection of the gaze ray, so it carries correct horizontal/vertical
        // scale instead of the compressed lookAtPoint magnitudes.
        if settings.useGeometric, let geo = geometricGaze(face: face) {
            hSig = geo.0
            vSig = geo.1
        }
        process(vertical: vSig, horizontal: hSig,
                pitch: headPitch(from: face.transform))
    }

    /// Project the eye gaze ray onto the device's screen plane → (horizontal,
    /// vertical) gaze point in nominal screen units (≈ −1…+1 across a ~14 cm plane;
    /// the exact scale and sign are absorbed by calibration). Needs the device pose
    /// (world tracking); returns nil when it isn't available or the ray is parallel
    /// to the screen, so the caller falls back to the lookAtPoint signal.
    private func geometricGaze(face: ARFaceAnchor) -> (Double, Double)? {
        guard let cam = session.currentFrame?.camera.transform else { return nil }
        let faceT = face.transform
        // Eye midpoint in world space.
        let lp = simd_mul(faceT, face.leftEyeTransform).columns.3
        let rp = simd_mul(faceT, face.rightEyeTransform).columns.3
        let eyeMid = simd_float3((lp.x + rp.x) * 0.5,
                                 (lp.y + rp.y) * 0.5,
                                 (lp.z + rp.z) * 0.5)
        // ARKit's gaze target (face-local) → world, then the ray direction.
        let lap = face.lookAtPoint
        let lapW = simd_mul(faceT, simd_float4(lap.x, lap.y, lap.z, 1))
        let dir = simd_normalize(simd_float3(lapW.x, lapW.y, lapW.z) - eyeMid)
        // Screen plane ≈ through the camera, normal = the device's Z axis.
        let camPos = simd_float3(cam.columns.3.x, cam.columns.3.y, cam.columns.3.z)
        let camX = simd_normalize(simd_float3(cam.columns.0.x, cam.columns.0.y, cam.columns.0.z))
        let camY = simd_normalize(simd_float3(cam.columns.1.x, cam.columns.1.y, cam.columns.1.z))
        let camZ = simd_normalize(simd_float3(cam.columns.2.x, cam.columns.2.y, cam.columns.2.z))
        let denom = simd_dot(dir, camZ)
        if abs(denom) < 1e-5 { return nil }
        let t = simd_dot(camPos - eyeMid, camZ) / denom
        if !t.isFinite { return nil }
        let hit = eyeMid + t * dir
        let rel = hit - camPos
        let half: Float = 0.07 // nominal half-screen in metres; scale absorbed by calibration
        // The front camera's sensor axes are landscape while the device is held
        // portrait, so the camera's X maps to the screen's VERTICAL and Y to the
        // HORIZONTAL — swap them. Per-axis sign is then absorbed by calibration.
        return (Double(simd_dot(rel, camY) / half), Double(simd_dot(rel, camX) / half))
    }

    /// Head pitch in radians, sign chosen so a downward nod is positive. Extracted
    /// from the face transform's forward axis. NOTE: the exact sign can vary by
    /// device orientation and is corrected by calibration + the tunable threshold.
    private func headPitch(from transform: simd_float4x4) -> Double {
        let forwardY = Double(transform.columns.2.y)
        return asin(max(-1.0, min(1.0, -forwardY)))
    }

    // MARK: - Core processing (testable entry point)

    /// Feed one signed vertical-gaze sample and one head-pitch sample. Public so
    /// unit tests can drive the engine without ARKit.
    func process(vertical rawVertical: Double, horizontal rawHorizontal: Double = 0,
                 pitch rawPitch: Double) {
        let alpha = min(max(settings.smoothing, 0.01), 1.0)
        if hasSample {
            filteredVertical += alpha * (rawVertical - filteredVertical)
            filteredHorizontal += alpha * (rawHorizontal - filteredHorizontal)
            filteredPitch += alpha * (rawPitch - filteredPitch)
        } else {
            filteredVertical = rawVertical
            filteredHorizontal = rawHorizontal
            filteredPitch = rawPitch
            hasSample = true
        }

        if previewing {
            // Normalized to the calibrated range (-1…+1 across the screen) so the
            // Dart dot maps with a plain fraction and inherits mirror-correctness.
            let gx = normed(filteredHorizontal - baseHorizontal, pos: hRightSpan, neg: hLeftSpan)
            let gy = normed(filteredVertical - baseVertical, pos: vDownSpan, neg: vUpSpan)
            let fv = filteredVertical, fh = filteredHorizontal, fp = filteredPitch
            if Thread.isMainThread {
                onPreview?(gx, gy, fv, fh, fp)
            } else {
                DispatchQueue.main.async { [weak self] in self?.onPreview?(gx, gy, fv, fh, fp) }
            }
        }

        if calibrating {
            calibrationSamples.append((filteredVertical, filteredHorizontal, filteredPitch))
            return
        }
        evaluate()
    }

    private func evaluate() {
        // Motion gate (ZUPT): while the phone itself is being moved/rotated quickly,
        // the face-relative signal is unreliable, so hold scrolling instead of acting
        // on garbage. World tracking handles slow movement; this catches the rest.
        if deviceAngularSpeed > Self.motionGate {
            applyDwell(.none, 0)
            return
        }
        // Both signals are normalized to the calibrated range: for the eyes this is
        // effectively *where on the screen you're looking* (−1 top … +1 bottom),
        // and for the head it is the tilt fraction.
        let eyePos = normed(filteredVertical - baseVertical, pos: vDownSpan, neg: vUpSpan)
        let headPos = normed(filteredPitch - basePitch, pos: pDownSpan, neg: pUpSpan)

        // Screen-fifths model for the eyes: the middle 3/5 is a firm dead zone, and
        // only looking into the outer fifths scrolls — down at the bottom, up at the
        // top. `threshold` is that dead-zone boundary (~0.6 ≈ the outer fifth). Head
        // tilt keeps its own lower boundary so head-only mode stays responsive.
        let eyeT = settings.threshold
        let headT = 0.5

        var signal = eyePos
        var t = eyeT
        switch settings.mode {
        case .eyesOnly:
            signal = eyePos; t = eyeT
        case .headOnly:
            signal = headPos; t = headT
        case .combined:
            // Use whichever the user is more clearly doing (further past its zone).
            if abs(headPos) - headT > abs(eyePos) - eyeT {
                signal = headPos; t = headT
            } else {
                signal = eyePos; t = eyeT
            }
        }

        // Hysteresis: once scrolling, hold until the gaze returns just inside the
        // dead-zone boundary, so it holds steadily at the edge but stops promptly
        // when you look back to the middle.
        let gate = pendingDirection == .none ? t : max(0.15, t - 0.10)
        var direction: GazeDecision.Direction = .none
        var intensity = 0.0
        if signal > gate {
            direction = .down
            intensity = intensityFor(signal - t, span: 1.0 - t)
        } else if signal < -gate {
            direction = .up
            intensity = intensityFor(-signal - t, span: 1.0 - t)
        }
        applyDwell(direction, intensity)
    }

    /// Map how far past the threshold the signal is into a 0…1 speed multiplier.
    private func intensityFor(_ over: Double, span: Double) -> Double {
        // `over` is how far past the dead-zone boundary the gaze is; `span` is the
        // room from there to the screen edge. Floor it so scrolling moves at a
        // usable speed the moment you cross into the outer fifth, then ramps up as
        // you look further toward the edge.
        let s = span <= 0.05 ? 0.4 : span
        return min(1.0, max(0.35, over / s))
    }

    private func applyDwell(_ direction: GazeDecision.Direction, _ intensity: Double) {
        let now = ProcessInfo.processInfo.systemUptime

        if direction == .none {
            pendingDirection = .none
            if lastEmitted.direction != .none {
                emit(GazeDecision(direction: .none, intensity: 0))
            }
            return
        }

        if direction != pendingDirection {
            pendingDirection = direction
            dwellStart = now
            return
        }

        // Held in the same direction — trigger once the dwell elapses, then keep
        // the intensity fresh.
        let heldMs = (now - dwellStart) * 1000.0
        if heldMs >= Double(settings.dwellMs) {
            emit(GazeDecision(direction: direction, intensity: intensity))
        }
    }

    /// Emit only when the decision meaningfully changes, to keep channel traffic
    /// low; the Dart side runs its own scroll loop between updates.
    private func emit(_ decision: GazeDecision) {
        if decision.direction == lastEmitted.direction,
           abs(decision.intensity - lastEmitted.intensity) < 0.08 {
            return
        }
        lastEmitted = decision
        if Thread.isMainThread {
            onDecision?(decision)
        } else {
            DispatchQueue.main.async { [weak self] in self?.onDecision?(decision) }
        }
    }
}
