//
//  ViewController.swift
//  Color Wheel
//
//  Created by A-Avramenko on 02.08.2024.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let complementaryViewController = ComplementaryViewController()
        let triadicViewController = TriadicViewController()
        let analogousViewController = AnalogousViewController()
        let splitCompViewController = SplitCompViewController()
        let tetradicViewController = TetradicViewController()
        let squareViewController = SquareViewController()

        complementaryViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Complementary scheme", comment: "Title for Complementary color scheme"),
            image: UIImage(systemName: "arrow.triangle.branch"),
            tag: 0
        )
        triadicViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Triadic scheme", comment: "Title for Triadic color scheme"),
            image: UIImage(systemName: "arrowtriangle.up"),
            tag: 1
        )
        analogousViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Analogous scheme", comment: "Title for Analogous color scheme"),
            image: UIImage(systemName: "arrow.up.and.down.righttriangle.up.righttriangle.down.fill"),
            tag: 2
        )
        splitCompViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Split Complementary scheme", comment: "Title for Split-Complementary color scheme"),
            image: UIImage(systemName: "arrowtriangle.down.fill"),
            tag: 3
        )
        tetradicViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tetradic scheme", comment: "Title for Tetradic color scheme"),
            image: UIImage(systemName: "envelope.arrow.triangle.branch.fill"),
            tag: 4
        )
        squareViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("About Color Wheel", comment: "Title for About section"),
            image: UIImage(systemName: "i.square.fill"),
            tag: 5
        )

        let tabBarList = [complementaryViewController, triadicViewController, analogousViewController, splitCompViewController, tetradicViewController, squareViewController]

        viewControllers = tabBarList
    }
}




