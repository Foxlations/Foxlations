import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    // Cold-start deep link: scene-based apps deliver the launch URL here, NOT in
    // AppDelegate launchOptions (always nil under scenes). Stash it before the
    // Flutter engine/plugins register, since app_links can miss the cold-start
    // scene event under the implicit-engine embedding. DeepLinkService pulls it
    // via the foxlations/deeplink channel on startup.
    if let url = connectionOptions.urlContexts.first?.url {
      AppDelegate.launchURL = url
    }
    super.scene(scene, willConnectTo: session, options: connectionOptions)
  }
}
