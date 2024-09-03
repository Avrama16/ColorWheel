
//  UITabBarController.swift
//  Color Wheel
//
//  Created by A-Avramenko on 04.08.2024.


import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private let toastLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        setupToastLabel()
        updateToastMessage()
        
        func viewController(for wheelType: WheelType) -> UIViewController {
            let viewController = WheelViewController(wheelType: wheelType)
            viewController.tabBarItem = UITabBarItem(title: "", image: wheelType.tabItemImage, selectedImage: nil)
            
            return viewController
        }
        
        viewControllers = WheelType.allCases.map { wheelType in
            viewController(for: wheelType)
        }
    }
    
    private func setupToastLabel() {
        let toastWidth = self.view.frame.size.width - 150
        let tabBarHeight = self.tabBar.frame.size.height
        let toastHeight: CGFloat = 35
        
        toastLabel.frame = CGRect(
            x: (self.view.frame.size.width - toastWidth) / 2,
            y: self.tabBar.frame.origin.y - tabBarHeight - 30, // Відступ над таббаром
            width: toastWidth,
            height: toastHeight
        )
//        view.addSubview(toastLabel)
    }
    
    private func showInitialTabBarItemInfo() {
        // Відображаємо інформацію про перший таббар айтем при запуску
        if let complementaryViewController = viewControllers?.first?.tabBarItem.title {
            toastLabel.text = complementaryViewController
        }
    }
    
    private func updateToastMessage() {
        if let selectedVC = selectedViewController, let tabBarItemTitle = selectedVC.tabBarItem.title {
            toastLabel.text = tabBarItemTitle
        }
    }
    
    // Метод викликається при зміні активної вкладки
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateToastMessage()
    }
}

extension WheelType {
    
    var tabItemTitle: String {
        switch self {
        case .analog: return "Complementary color scheme"
        case .tab2: return "Triadic color scheme"
        case .tab3: return "Analogous color scheme"
        case .tab4: return "Split-Complementary color scheme"
        case .tab5: return "Tetradic color scheme"
        }
    }
    
    var tabItemImage: UIImage? {
        return switch self {
        case .analog: UIImage(systemName: "arrow.triangle.branch")
        case .tab2: UIImage(systemName: "arrowtriangle.up")
        case .tab3: UIImage(systemName: "arrow.up.and.down.righttriangle.up.righttriangle.down.fill")
        case .tab4: UIImage(systemName: "arrowtriangle.down.fill")
        case .tab5: UIImage(systemName: "envelope.arrow.triangle.branch.fill")
        }
    }
}
