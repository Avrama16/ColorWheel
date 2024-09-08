//
//  RotatingWheelView.swift
//  Color Wheel
//
//  Created by A-Avramenko on 12.08.2024.
//

import UIKit

class RotatingWheel: UIImageView {
    
    private var currentRotation: CGFloat = 0
    private var lastRotation: CGFloat = 0
    
    init(wheelType: WheelType) {
        super.init(image: wheelType.rotatingOverlayImage)
        
        setupView()
        addRotationGesture()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func setupView() {
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
    }
    private func addRotationGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        switch gesture.state {
        case .began:
            lastRotation = atan2(translation.y, translation.x)
        case .changed:
            let newRotation = atan2(translation.y, translation.x)
            let rotationDelta = newRotation - lastRotation
            currentRotation += rotationDelta
            transform = CGAffineTransform(rotationAngle: currentRotation)
            lastRotation = newRotation
        case .ended:
            lastRotation = 0
        default:
            break
        }
    }
    
    func resetRotation() {
        currentRotation = 0
        transform = CGAffineTransform.identity
    }
}
    extension WheelType {
        
        var rotatingOverlayImage: UIImage? {
            return switch self {
            case .type1: UIImage.wheelTypeAnalog
            case .type2: UIImage.wheelTypeComplemet
            case .type3: UIImage.wheelTypeTriadic
            case .type4: UIImage.wheelTypeTetradic
            case .type5: UIImage.wheelTypeSplitComplement
            default: nil
            }
        }
    }

