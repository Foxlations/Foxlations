import ARKit
import Flutter
import Foundation
import UIKit

/// Bridges the pure `GazeScroller` engine to Flutter over `foxlations/gaze`.
///
/// Follows the app's existing channel conventions: registered from
/// `AppDelegate.didInitializeImplicitFlutterEngine` with the implicit-engine
/// messenger (like the deeplink channel), and streams native→Dart events by
/// reverse-invoking a method (`onGaze`) into Dart's handler — the same pattern
/// `volume_keys.dart` uses, since the project has no EventChannel.
final class GazeChannel {
    private let channel: FlutterMethodChannel
    private let scroller = GazeScroller()

    /// Whether the reader last asked for tracking, so returning to the foreground
    /// can resume it (and backgrounding can pause without forgetting intent).
    private var wantsActive = false
    private var observers: [NSObjectProtocol] = []

    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: "foxlations/gaze", binaryMessenger: messenger)
        channel.setMethodCallHandler { [weak self] call, result in
            self?.handle(call, result)
        }
        scroller.onDecision = { [weak self] decision in
            self?.channel.invokeMethod("onGaze", arguments: [
                "direction": decision.direction.rawValue,
                "intensity": decision.intensity,
            ])
        }
        scroller.onPreview = { [weak self] gx, gy, fv, fh, fp in
            self?.channel.invokeMethod("onGazePreview",
                                       arguments: ["gx": gx, "gy": gy, "fv": fv, "fh": fh, "fp": fp])
        }
        observeLifecycle()
    }

    deinit {
        observers.forEach { NotificationCenter.default.removeObserver($0) }
        scroller.stop()
    }

    // MARK: - Dart → native

    private func handle(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "isSupported":
            result(GazeScroller.isSupported)

        case "setActive":
            let active = (call.arguments as? Bool) ?? false
            wantsActive = active
            if active {
                guard GazeScroller.isSupported else {
                    result(FlutterError(code: "unsupported",
                                        message: "Face tracking is not supported on this device.",
                                        details: nil))
                    return
                }
                scroller.start()
            } else {
                scroller.pause()
            }
            result(nil)

        case "updateSettings":
            if let map = call.arguments as? [String: Any] {
                applySettings(map)
            }
            result(nil)

        case "calibrate":
            let ms: Int
            let adopt: Bool
            if let m = call.arguments as? [String: Any] {
                ms = (m["durationMs"] as? NSNumber)?.intValue ?? 1500
                adopt = (m["adopt"] as? Bool) ?? true
            } else {
                ms = (call.arguments as? NSNumber)?.intValue ?? 1500
                adopt = true
            }
            let wasRunning = scroller.isRunning
            if !wasRunning { scroller.start() }
            scroller.calibrate(durationMs: ms, adopt: adopt) { [weak self] v, h, p in
                if !wasRunning { self?.scroller.pause() }
                self?.channel.invokeMethod("onCalibrated",
                                           arguments: ["v": v, "h": h, "p": p])
            }
            result(nil)

        case "setPreview":
            let on = (call.arguments as? Bool) ?? false
            if on, !scroller.isRunning { scroller.start() }
            scroller.setPreview(on)
            result(nil)

        case "setBaseline":
            if let m = call.arguments as? [String: Any] {
                scroller.applyBaseline(
                    (m["v"] as? NSNumber)?.doubleValue ?? 0,
                    (m["h"] as? NSNumber)?.doubleValue ?? 0,
                    (m["p"] as? NSNumber)?.doubleValue ?? 0)
            }
            result(nil)

        case "setModel":
            if let m = call.arguments as? [String: Any] {
                func d(_ k: String, _ fallback: Double) -> Double {
                    (m[k] as? NSNumber)?.doubleValue ?? fallback
                }
                scroller.applyModel(
                    baseV: d("v", 0), baseH: d("h", 0), baseP: d("p", 0),
                    vDown: d("down", 0.45), vUp: d("up", -0.35),
                    hRight: d("right", 0.35), hLeft: d("left", -0.35),
                    pDown: d("pdown", 0.25), pUp: d("pup", -0.22))
            }
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func applySettings(_ map: [String: Any]) {
        var s = scroller.settings
        if let mode = map["mode"] as? String, let m = GazeSettings.Mode(rawValue: mode) {
            s.mode = m
        }
        if let t = map["threshold"] as? NSNumber { s.threshold = t.doubleValue }
        if let d = map["dwellMs"] as? NSNumber { s.dwellMs = d.intValue }
        if let sm = map["smoothing"] as? NSNumber { s.smoothing = sm.doubleValue }
        if let u = map["useLookAt"] as? NSNumber { s.useLookAt = u.boolValue }
        if let g = map["useGeometric"] as? NSNumber { s.useGeometric = g.boolValue }
        scroller.settings = s
    }

    // MARK: - Lifecycle (pause the camera in the background to save battery)

    private func observeLifecycle() {
        let nc = NotificationCenter.default
        observers.append(nc.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil, queue: .main) { [weak self] _ in
                self?.scroller.pause()
            })
        observers.append(nc.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil, queue: .main) { [weak self] _ in
                guard let self = self, self.wantsActive, GazeScroller.isSupported else { return }
                self.scroller.start()
            })
    }
}
