import AVFoundation
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  /// The URL that cold-launched the app via a custom scheme (mihon://, etc.).
  /// This app is scene-based, so it's captured in SceneDelegate.scene(willConnectTo:)
  /// — before Flutter plugins register — because app_links can miss the cold-start
  /// scene event under the implicit-engine embedding. Dart pulls it via the
  /// foxlations/deeplink channel. Consumed once.
  static var launchURL: URL?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // media_kit never touches AVAudioSession, so iOS leaves us on the default
    // .soloAmbient category — video audio is muted by the hardware Ring/Silent
    // switch and playback stops the moment the app is backgrounded. Neither
    // happens on Android, so it reads as "video is broken" on iOS.
    // Requires the `audio` entry in UIBackgroundModes (Info.plist).
    try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
    try? AVAudioSession.sharedInstance().setActive(true)

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

    #if FOXLATIONS_JVM
    // Embedded-JVM channel for Kotlin extensions. Only present in the JVM build
    // (the -DFOXLATIONS_JVM configuration); a no-op in the normal production build.
    registerFoxJvmChannel(engineBridge.pluginRegistry)
    #endif
  }
}
