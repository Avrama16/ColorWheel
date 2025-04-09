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
        print("SceneDelegate: scene willConnectTo called")
        guard let windowScene = (scene as? UIWindowScene) else { 
            print("SceneDelegate: Failed to get windowScene")
            return 
        }
        
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .white
        print("SceneDelegate: Creating CustomTabBarController")
        let tabBarController = CustomTabBarController()
        window.rootViewController = tabBarController
        self.window = window
        print("SceneDelegate: Making window key and visible")
        window.makeKeyAndVisible()
        print("SceneDelegate: Scene setup completed")
    }
}
