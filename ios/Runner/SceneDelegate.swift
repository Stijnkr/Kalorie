import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  private let privacyTag = 918273

  override func sceneWillResignActive(_ scene: UIScene) {
    super.sceneWillResignActive(scene)
    guard let windowScene = scene as? UIWindowScene else { return }
    for window in windowScene.windows {
      if window.viewWithTag(privacyTag) != nil { continue }
      let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterial))
      blur.frame = window.bounds
      blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      blur.tag = privacyTag
      window.addSubview(blur)
    }
  }

  override func sceneDidBecomeActive(_ scene: UIScene) {
    super.sceneDidBecomeActive(scene)
    guard let windowScene = scene as? UIWindowScene else { return }
    for window in windowScene.windows {
      window.viewWithTag(privacyTag)?.removeFromSuperview()
    }
  }
}
