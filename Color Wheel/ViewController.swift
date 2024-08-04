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


        complementaryViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "arrow.triangle.branch"), tag: 0)
        triadicViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "arrowtriangle.up"), tag: 1)
        analogousViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "arrow.up.and.down.righttriangle.up.righttriangle.down.fill"), tag: 2)
        splitCompViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "arrowtriangle.down.fill"), tag: 3)
        tetradicViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "envelope.arrow.triangle.branch.fill"), tag: 4)
        squareViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "i.square.fill"), tag: 5)


        let tabBarList = [complementaryViewController, triadicViewController, analogousViewController, splitCompViewController, tetradicViewController, squareViewController]

        viewControllers = tabBarList
    }
}




