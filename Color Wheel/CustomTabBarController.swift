//  UITabBarController.swift
//  Color Wheel
//
//  Created by A-Avramenko on 04.08.2024.


import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // Додаємо властивість для зберігання стану колеса
    var currentStaticWheelType: StaticWheelType {
        get {
            let rawValue = UserDefaults.standard.integer(forKey: "StaticWheelTypeState")
            return StaticWheelType(rawValue: rawValue) ?? .type1
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "StaticWheelTypeState")
            updateAllWheelViewControllers()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CustomTabBarController: viewDidLoad called")
        self.delegate = self
        
        // Налаштування стилю таббару
        tabBar.backgroundColor = .white
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .lightGray
        
        // Додаємо розділювальну лінію
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: tabBar.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        setupViewControllers()
        print("CustomTabBarController: setupViewControllers completed")
    }
    
    // Метод для оновлення всіх WheelViewController
    private func updateAllWheelViewControllers() {
        for case let navigationController as UINavigationController in viewControllers ?? [] {
            if let wheelViewController = navigationController.viewControllers.first as? WheelViewController {
                wheelViewController.updateWheelType(currentStaticWheelType)
            }
        }
    }
    
    // Додаємо анімацію для плавного переходу
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view,
              let toView = viewController.view,
              fromView != toView else { return true }
        
        UIView.transition(from: fromView, to: toView, duration: 0.3, options: .transitionCrossDissolve, completion: nil)
        return true
    }
    
    private func setupViewControllers() {
        print("CustomTabBarController: Setting up view controllers")
        let viewControllers = [
            createViewController(for: .type2),
            createViewController(for: .type3),
            createViewController(for: .type1),
            createViewController(for: .type5),
            createViewController(for: .type4)
        ]
        
        setViewControllers(viewControllers, animated: false)
        print("CustomTabBarController: View controllers set: \(viewControllers.count)")
    }
    
    private func createViewController(for wheelType: WheelType) -> UIViewController {
        print("CustomTabBarController: Creating view controller for wheelType: \(wheelType)")
        let viewController = WheelViewController(wheelType: wheelType)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.tintColor = .black
        navigationController.navigationBar.isTranslucent = false
        viewController.tabBarItem = UITabBarItem(title: "", image: wheelType.tabItemImage, selectedImage: wheelType.tabItemImage?.withRenderingMode(.alwaysOriginal))
        
        return navigationController
    }
}
