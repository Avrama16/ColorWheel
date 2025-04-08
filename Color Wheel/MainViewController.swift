//
//  MainViewController.swift
//  Color Wheel
//
//  Created by A-Avramenko on 12.08.2024.
//

import UIKit

class MainViewController: CustomTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Language", style: .plain, target: self, action: #selector(showLanguageSelection))
    }
    
    @objc func showLanguageSelection() {
        let languageSelectionVC = LanguageSelectionViewController()
        navigationController?.pushViewController(languageSelectionVC, animated: true)
    }
}
