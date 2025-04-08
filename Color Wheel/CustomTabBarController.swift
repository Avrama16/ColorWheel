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
        
        func viewController(for wheelType: WheelType) -> UIViewController {
            let viewController = WheelViewController(wheelType: wheelType)
            viewController.tabBarItem = UITabBarItem(title: "", image: wheelType.tabItemImage, selectedImage: wheelType.tabItemImage?.withRenderingMode(.alwaysOriginal))
            
            return viewController
        }
        viewControllers = WheelType.allCases.map { wheelType in
            UINavigationController(rootViewController: viewController(for: wheelType))
        }
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
}

extension WheelType {
    
    var tabItemTitle: String {
        switch self {
        case .type2: return "Complementary color scheme"
        case .type4: return "Tetradic color scheme"
        case .type1: return "Analogous color scheme"
        case .type5: return "Split-Complementary color scheme"
        case .type3: return "Triadic color scheme"
        }
    }
    
    var tabItemImage: UIImage? {
        return switch self {
        case .type2: UIImage.compBar
        case .type4: UIImage.tetradBar
        case .type1: UIImage.analogBar
        case .type5: UIImage.splitCompBar
        case .type3: UIImage.triadBar
        }
    }
}
