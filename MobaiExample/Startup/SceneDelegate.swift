//
//  SceneDelegate.swift
//  InjectionAttackExample
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var navigationController = UINavigationController()
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        navigationController = UINavigationController()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let viewController = MBCaptureSessionViewController(with: .init(isDebugging: true, captureConstraints: .v2), style: .init())
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
