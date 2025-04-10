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
            return NSLocalizedString("Complementary scheme", comment: "Title for Complementary color scheme")
        case .tab2:
            return NSLocalizedString("Triadic scheme", comment: "Title for Triadic color scheme")
        case .tab3:
            return NSLocalizedString("Analogous scheme", comment: "Title for Analogous color scheme")
        case .tab4:
            return NSLocalizedString("Split Complementary scheme", comment: "Title for Split-Complementary color scheme")
        case .tab5:
            return NSLocalizedString("Tetradic scheme", comment: "Title for Tetradic color scheme")
        }
    }
}
