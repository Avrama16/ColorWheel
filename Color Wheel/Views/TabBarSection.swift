//
//  TabBarSection.swift
//  Color Wheel
//
//  Created by A-Avramenko on 03.09.2024.
//

import Foundation

enum WheelType: Int {
    case tab1
    case tab2
    case tab3
    case tab4
    case tab5
    
    // Метод для отримання назви вкладки, якщо потрібно
    func tabTitle() -> String {
        switch self {
        case .tab1:
            return "Complementary color scheme"
        case .tab2:
            return "Triadic color scheme"
        case .tab3:
            return "Analogous color scheme"
        case .tab4:
            return "Split-Complementary color scheme"
        case .tab5:
            return "Tetradic color scheme"
        }
    }
}
