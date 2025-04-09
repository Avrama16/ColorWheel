import UIKit

class RotatingWheel: UIImageView {
    
    private var currentRotation: CGFloat = 0
    private let numberOfSections: Int = 12
    private var lastRotation: CGFloat = 0
    private var lastPoint: CGPoint?
    private var lastAngle: CGFloat = 0
    private var lastVelocity: CGPoint = .zero
    private var targetRotation: CGFloat = 0
    private var displayLink: CADisplayLink?
    private var smoothingFactor: CGFloat = 0.4 // Зменшуємо фактор згладжування для ще більш швидкої реакції
    private let rotationSpeedMultiplier: CGFloat = 2.0 // Збільшуємо множник швидкості
    
    init(wheelType: WheelType) {
        print("RotatingWheel: Initializing with wheelType: \(wheelType)")
        let image = wheelType.rotatingOverlayImage
        print("RotatingWheel: rotatingOverlayImage is \(image != nil ? "loaded" : "nil")")
        super.init(image: image)
        print("RotatingWheel: Initializing with wheelType: \(wheelType)")
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("RotatingWheel: Initializing from coder")
        setupView()
    }
    
    private func setupView() {
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
        print("RotatingWheel: Setup view - isUserInteractionEnabled: \(isUserInteractionEnabled)")
        
        // Додаємо pan gesture
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(gesture)
        print("RotatingWheel: Added pan gesture recognizer")
        
        // Створюємо display link для плавного обертання
        displayLink = CADisplayLink(target: self, selector: #selector(updateRotation))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    deinit {
        displayLink?.invalidate()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("RotatingWheel: Layout subviews - frame: \(frame), bounds: \(bounds)")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        print("RotatingWheel: Did move to superview - superview: \(String(describing: superview))")
        checkGestureRecognizers()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        print("RotatingWheel: Did move to window - window: \(String(describing: window))")
    }
    
    private func checkGestureRecognizers() {
        print("RotatingWheel: Checking gesture recognizers")
        if let recognizers = gestureRecognizers {
            print("RotatingWheel: Found \(recognizers.count) gesture recognizers")
            for (index, recognizer) in recognizers.enumerated() {
                print("RotatingWheel: Recognizer \(index): \(recognizer)")
            }
        } else {
            print("RotatingWheel: No gesture recognizers found")
        }
    }
    
    @objc private func updateRotation() {
        // Інтерполяція між поточним і цільовим кутом
        let diff = targetRotation - currentRotation
        
        // Нормалізуємо різницю
        var normalizedDiff = diff
        if normalizedDiff > .pi {
            normalizedDiff -= 2 * .pi
        } else if normalizedDiff < -.pi {
            normalizedDiff += 2 * .pi
        }
        
        // Застосовуємо згладжування з урахуванням швидкості
        if abs(normalizedDiff) > 0.001 {
            let speed = min(abs(normalizedDiff) * rotationSpeedMultiplier, 1.0)
            currentRotation += normalizedDiff * smoothingFactor * speed
            transform = CGAffineTransform(rotationAngle: currentRotation)
        }
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let velocity = gesture.velocity(in: self)
        
        print("RotatingWheel: Pan gesture state: \(gesture.state.rawValue)")
        print("RotatingWheel: Pan location: \(location)")
        print("RotatingWheel: Pan velocity: \(velocity)")
        
        switch gesture.state {
        case .began:
            lastPoint = location
            lastRotation = currentRotation
            lastAngle = atan2(location.y - center.y, location.x - center.x)
            lastVelocity = velocity
            print("RotatingWheel: Pan began - lastPoint: \(String(describing: lastPoint))")
            
        case .changed:
            guard let lastPoint = lastPoint else { return }
            
            // Розраховуємо кут між поточною точкою та центром
            let currentAngle = atan2(location.y - center.y, location.x - center.x)
            
            // Розраховуємо різницю кутів
            var angleDifference = currentAngle - lastAngle
            
            // Нормалізуємо кут
            if angleDifference > .pi {
                angleDifference -= 2 * .pi
            } else if angleDifference < -.pi {
                angleDifference += 2 * .pi
            }
            
            // Оновлюємо цільовий кут з урахуванням швидкості
            let speed = min(sqrt(pow(velocity.x, 2) + pow(velocity.y, 2)) / 800, 1.0) // Зменшуємо знаменник для більшої чутливості
            targetRotation += angleDifference * (1 + speed)
            
            // Оновлюємо останній кут
            lastAngle = currentAngle
            
            print("RotatingWheel: Pan changed - angleDifference: \(angleDifference), targetRotation: \(targetRotation)")
            
        case .ended, .cancelled:
            print("RotatingWheel: Pan ended/cancelled - currentRotation: \(currentRotation)")
            lastPoint = nil
            snapToNearestSection()
            
        default:
            print("RotatingWheel: Pan other state: \(gesture.state.rawValue)")
            break
        }
    }
    
    private func snapToNearestSection() {
        let sectionAngle = (2 * .pi) / CGFloat(numberOfSections)
        let normalizedRotation = targetRotation.truncatingRemainder(dividingBy: 2 * .pi)
        let nearestSection = round(normalizedRotation / sectionAngle)
        let targetAngle = nearestSection * sectionAngle
        
        print("RotatingWheel: Snapping to section - current: \(normalizedRotation), target: \(targetAngle)")
        
        // Плавно переходимо до цільового кута
        targetRotation = targetAngle
        
        // Змінюємо фактор згладжування для швидшого притискання
        let originalSmoothingFactor = smoothingFactor
        smoothingFactor = 0.3 // Зменшуємо для ще швидшого притискання
        
        // Повертаємо оригінальний фактор згладжування після анімації
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in // Зменшуємо час анімації
            self?.smoothingFactor = originalSmoothingFactor
        }
    }
        
    func resetRotation() {
        currentRotation = 0
        targetRotation = 0
        lastRotation = 0
        lastPoint = nil
        lastAngle = 0
        lastVelocity = .zero
        transform = CGAffineTransform.identity
        print("RotatingWheel: Reset rotation")
    }
    
    func updateWheelType(_ type: WheelType) {
        image = type.rotatingOverlayImage
        print("RotatingWheel: Updated wheel type to \(type)")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2
        let distance = sqrt(pow(point.x - center.x, 2) + pow(point.y - center.y, 2))
        let isInside = distance <= radius
        print("RotatingWheel: Point inside check - point: \(point), isInside: \(isInside)")
        return isInside
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("RotatingWheel: Hit test - point: \(point)")
        let result = super.hitTest(point, with: event)
        print("RotatingWheel: Hit test result: \(String(describing: result))")
        return result
    }
}

extension WheelType {
    var rotatingOverlayImage: UIImage? {
        switch self {
        case .type1: return UIImage(named: "wheelTypeAnalog")
        case .type2: return UIImage(named: "wheelTypeComplemet")
        case .type3: return UIImage(named: "wheelTypeTriadic")
        case .type4: return UIImage(named: "wheelTypeTetradic")
        case .type5: return UIImage(named: "wheelTypeSplitComplement")
        }
    }
}
