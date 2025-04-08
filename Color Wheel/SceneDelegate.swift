//
//  SceneDelegate.swift
//  Color Wheel
//
//  Created by A-Avramenko on 02.08.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .white
        window.rootViewController = CustomTabBarController()
        self.window = window
        window.makeKeyAndVisible()
    }
}
