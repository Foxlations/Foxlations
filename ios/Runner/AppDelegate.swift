import AVFoundation
import Flutter
import UIKit
import UniformTypeIdentifiers
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  /// The URL that cold-launched the app via a custom scheme (mihon://, etc.).
  /// This app is scene-based, so it's captured in SceneDelegate.scene(willConnectTo:)
  /// — before Flutter plugins register — because app_links can miss the cold-start
  /// scene event under the implicit-engine embedding. Dart pulls it via the
  /// foxlations/deeplink channel. Consumed once.
  static var launchURL: URL?

  /// Hands-free (gaze) scrolling bridge; retained for the app's lifetime.
  private var gazeChannel: GazeChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Ignore SIGPIPE process-wide. A socket (rhttp/dio, or the embedded JVM's
    // OkHttp) torn down by the OS while the app is suspended would otherwise
    // raise SIGPIPE on the next write after resume; its default disposition is
    // lethal. Set before the JVM boots so its signal snapshot captures SIG_IGN
    // too. Standard for networked iOS apps; closes one reopen-from-background
    // crash path (see the signal-handler notes below).
    signal(SIGPIPE, SIG_IGN)

    // media_kit never touches AVAudioSession, so iOS leaves us on the default
    // .soloAmbient category — video audio is muted by the hardware Ring/Silent
    // switch and playback stops the moment the app is backgrounded. Neither
    // happens on Android, so it reads as "video is broken" on iOS.
    // Requires the `audio` entry in UIBackgroundModes (Info.plist).
    try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
    try? AVAudioSession.sharedInstance().setActive(true)

    // flutter_local_notifications: become the notification-center delegate so
    // notifications also present while the app is in the foreground.
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    #if FOXLATIONS_JVM
    // Re-assert the app's crash-signal handlers across the whole background
    // window. The embedded Zero VM arms process-wide SIGSEGV/SIGBUS handlers
    // during a JVM op; a benign WebKit/RunningBoard signal in the
    // background<->foreground window would otherwise reach the JVM handler and
    // SIGABRT (ShouldNotReachHere on bsd_zero arm64) — the reopen-from-background
    // crash. Restoring on the way OUT (resign/enter-background) means the app
    // already owns the signals before a wake-time signal can fire — closing the
    // "resume races the foreground observer" window that restoring only on the
    // way IN leaves open. Restoring on the way back (foreground/active) too.
    // Idempotent + cheap.
    let nc = NotificationCenter.default
    for name in [
      UIApplication.willResignActiveNotification,
      UIApplication.didEnterBackgroundNotification,
      UIApplication.willEnterForegroundNotification,
      UIApplication.didBecomeActiveNotification,
    ] {
      nc.addObserver(forName: name, object: nil, queue: .main) { _ in
        FoxJvmRestoreSignals()
      }
    }
    #endif

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // Hand the captured cold-start URL to Dart (DeepLinkService).
    let messenger = engineBridge.applicationRegistrar.messenger()
    let channel = FlutterMethodChannel(
      name: "foxlations/deeplink",
      binaryMessenger: messenger)
    channel.setMethodCallHandler { (call, result) in
      if call.method == "getColdStartLink" {
        result(AppDelegate.launchURL?.absoluteString)
        AppDelegate.launchURL = nil
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    // Hands-free scrolling: ARKit face tracking -> gaze events (iOS only). The
    // channel is always registered; it no-ops on devices without a TrueDepth
    // camera (GazeScroller.isSupported gates the feature).
    gazeChannel = GazeChannel(messenger: messenger)

    // Secure Screen: cover the window with a blur while inactive so app content
    // is hidden in the app switcher (iOS has no FLAG_SECURE equivalent).
    SecureScreen.register(messenger: messenger)

    // Folder access: let the user pick a folder outside the sandbox (local
    // sources) and keep reading it across launches via a security-scoped
    // bookmark. iOS-only; Android/Windows use the plain directory picker.
    FolderAccess.register(messenger: messenger)

    // Background downloads: ask iOS for extra background time while a download
    // is active, so it keeps going for the few minutes the OS grants after the
    // app is backgrounded (iOS can't run our segment-fetch pipeline once the
    // app is fully suspended; Dart persists + resumes the queue for the rest).
    BackgroundRunner.register(messenger: messenger)

    #if FOXLATIONS_JVM
    // Embedded-JVM channel for Kotlin extensions. Only present in the JVM build
    // (the -DFOXLATIONS_JVM configuration); a no-op in the normal production build.
    registerFoxJvmChannel(engineBridge.pluginRegistry)
    #endif
  }
}

/// Background downloads. iOS suspends the app shortly after it's backgrounded,
/// which would stop an in-progress download. `beginBackgroundTask` asks for the
/// finite extra time the OS grants (seconds to a few minutes) so the current
/// download(s) can finish; the Dart side (DownloadProvider) persists the queue
/// and resumes anything left when the app returns. Dart drives it over
/// foxlations/background: `begin` when a download starts, `end` when the queue
/// drains. Idempotent. Kept in AppDelegate.swift (already in the Runner target)
/// to avoid a new project.pbxproj entry — same rationale as SecureScreen.
enum BackgroundRunner {
  private static var taskId: UIBackgroundTaskIdentifier = .invalid

  static func register(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "foxlations/background", binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "begin": begin(); result(nil)
      case "end": end(); result(nil)
      default: result(FlutterMethodNotImplemented)
      }
    }
  }

  private static func begin() {
    DispatchQueue.main.async {
      guard taskId == .invalid else { return }
      taskId = UIApplication.shared.beginBackgroundTask(withName: "foxlations.downloads") {
        end()  // expiration handler — release before iOS force-ends us
      }
    }
  }

  private static func end() {
    DispatchQueue.main.async {
      guard taskId != .invalid else { return }
      UIApplication.shared.endBackgroundTask(taskId)
      taskId = .invalid
    }
  }
}

/// Secure Screen (Settings > Security). iOS has no FLAG_SECURE, so when enabled we
/// hide app content in the app switcher by covering the key window with a blur
/// while the app is inactive. Dart pushes the on/off state over foxlations/secure.
/// Kept in AppDelegate.swift (already in the Runner target) rather than a new file,
/// which would need a project.pbxproj entry.
enum SecureScreen {
  static var enabled = false
  private static var cover: UIView?

  static func register(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "foxlations/secure", binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      if call.method == "setSecure" {
        enabled = (call.arguments as? Bool) ?? false
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    let nc = NotificationCenter.default
    nc.addObserver(forName: UIApplication.willResignActiveNotification,
                   object: nil, queue: .main) { _ in if enabled { showCover() } }
    nc.addObserver(forName: UIApplication.didBecomeActiveNotification,
                   object: nil, queue: .main) { _ in hideCover() }
  }

  private static func keyWindow() -> UIWindow? {
    let windows = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
    return windows.first(where: { $0.isKeyWindow }) ?? windows.first
  }

  private static func showCover() {
    guard cover == nil, let window = keyWindow() else { return }
    let v = UIView(frame: window.bounds)
    v.backgroundColor = .systemBackground
    v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    blur.frame = v.bounds
    blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    v.addSubview(blur)
    window.addSubview(v)
    cover = v
  }

  private static func hideCover() {
    cover?.removeFromSuperview()
    cover = nil
  }
}

/// Folder access (Local sources > Add folder). iOS hands back a security-scoped
/// URL from the document picker that the app can't simply re-open later by path,
/// so we persist a bookmark and resolve it (re-acquiring the security scope) on
/// each launch. Dart drives it over foxlations/folder:
///   pickFolder      -> {path, bookmark} (base64) | nil (cancelled/failed)
///   resolveBookmark -> {path, bookmark} | nil  (starts access; refreshes stale)
/// Access started here is kept for the app's lifetime (the URLs are retained in
/// activeURLs), which is the documented pattern for a long-lived scoped folder.
/// Kept in AppDelegate.swift (already in the Runner target) to avoid a new
/// project.pbxproj entry — same rationale as SecureScreen.
enum FolderAccess {
  private static var pickerDelegate: FolderPickerDelegate?
  private static var activeURLs: [String: URL] = [:]  // bookmark(base64) -> accessing URL

  static func register(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "foxlations/folder", binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "pickFolder":
        pickFolder(result)
      case "resolveBookmark":
        result(resolve(call.arguments as? String))
      case "release":
        if let b64 = call.arguments as? String, let url = activeURLs.removeValue(forKey: b64) {
          url.stopAccessingSecurityScopedResource()
        }
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private static func rootViewController() -> UIViewController? {
    let windows = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
    let window = windows.first(where: { $0.isKeyWindow }) ?? windows.first
    var top = window?.rootViewController
    while let presented = top?.presentedViewController { top = presented }
    return top
  }

  private static func pickFolder(_ result: @escaping FlutterResult) {
    DispatchQueue.main.async {
      guard let root = rootViewController() else { result(nil); return }
      let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder], asCopy: false)
      picker.allowsMultipleSelection = false
      let delegate = FolderPickerDelegate { url in
        pickerDelegate = nil
        guard let url = url else { result(nil); return }
        let didAccess = url.startAccessingSecurityScopedResource()
        do {
          let data = try url.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)
          let b64 = data.base64EncodedString()
          activeURLs[b64] = url  // keep the scope alive for this session
          result(["path": url.path, "bookmark": b64])
        } catch {
          if didAccess { url.stopAccessingSecurityScopedResource() }
          result(nil)
        }
      }
      pickerDelegate = delegate
      picker.delegate = delegate
      root.present(picker, animated: true)
    }
  }

  private static func resolve(_ b64: String?) -> [String: Any]? {
    guard let b64 = b64, let data = Data(base64Encoded: b64) else { return nil }
    if let existing = activeURLs[b64] { return ["path": existing.path, "bookmark": b64] }
    var stale = false
    guard let url = try? URL(resolvingBookmarkData: data, options: [],
                             relativeTo: nil, bookmarkDataIsStale: &stale) else { return nil }
    guard url.startAccessingSecurityScopedResource() else { return nil }
    var outB64 = b64
    if stale,
       let fresh = try? url.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil) {
      outB64 = fresh.base64EncodedString()
    }
    activeURLs[outB64] = url
    return ["path": url.path, "bookmark": outB64]
  }
}

final class FolderPickerDelegate: NSObject, UIDocumentPickerDelegate {
  private let completion: (URL?) -> Void
  init(_ completion: @escaping (URL?) -> Void) { self.completion = completion }

  func documentPicker(_ controller: UIDocumentPickerViewController,
                      didPickDocumentsAt urls: [URL]) {
    completion(urls.first)
  }

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    completion(nil)
  }
}
