//
//  RotatingWheelView.swift
//  Color Wheel
//
//  Created by A-Avramenko on 12.08.2024.
//

import UIKit

class RotatingWheel: UIImageView {
    
    private var currentRotation: CGFloat = 0

    init(wheelType: WheelType) {
        super.init(image: wheelType.rotatingOverlayImage)
        
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }

    private func setupView() {
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
    }

    func rotate(by rotationAmount: CGFloat) {
        transform = CGAffineTransform(rotationAngle: currentRotation + rotationAmount)
        currentRotation += rotationAmount
    }

    func resetRotation() {
        // Скидання обертання до початкового стану
        currentRotation = 0
        transform = CGAffineTransform.identity
    }
}

extension WheelType {
    
    var rotatingOverlayImage: UIImage? {
        return switch self {
        case .analog: UIImage.wheelTypeAnalog
        default: nil
        }
    }
}
