
//  UITabBarController.swift
//  Color Wheel
//
//  Created by A-Avramenko on 04.08.2024.


import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        func viewController(for wheelType: WheelType) -> UIViewController {
            let viewController = WheelViewController(wheelType: wheelType)
            viewController.tabBarItem = UITabBarItem(title: "", image: wheelType.tabItemImage, selectedImage: wheelType.tabItemImage?.withRenderingMode(.alwaysOriginal))
            
            return viewController
        }
        viewControllers = WheelType.allCases.map { wheelType in
            viewController(for: wheelType)
        }
    }
}

extension WheelType {
    
    var tabItemTitle: String {
        switch self {
        case .type1: return "Analogous color scheme"
        case .type2: return "Complementary color scheme"
        case .type3: return "Triadic color scheme"
        case .type4: return "Tetradic color scheme"
        case .type5: return "Split-Complementary color scheme"
        }
    }
    
    var tabItemImage: UIImage? {
        return switch self {
        case .type1: UIImage.analogBar
        case .type2: UIImage.compBar
        case .type3: UIImage.triadBar
        case .type4: UIImage.tetradBar
        case .type5: UIImage.splitCompBar
        }
    }
}
