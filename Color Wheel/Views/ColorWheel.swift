import UIKit

// судячи з усього цей клас не потрібний, бо він тільки сетапить властивості UIImageView
class ColorWheel: UIImageView {

    init() {
        print("ColorWheel: Initializing")
        let wheelImage = UIImage(named: "ColorStaticBase")
        print("ColorWheel: wheelImage is \(wheelImage != nil ? "loaded" : "nil")")
        super.init(image: wheelImage)
        setupView()
    }

    required init?(coder: NSCoder) {
        print("ColorWheel: Initializing from coder")
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        print("ColorWheel: Setting up view")
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        print("ColorWheel: Did move to superview: \(String(describing: superview))")
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        print("ColorWheel: Did move to window: \(String(describing: window))")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("ColorWheel: Layout subviews - frame: \(frame)")
    }
}

extension WheelType {
    
    var staticWheelType: UIImage? {
        return switch self {
        case .type1: UIImage.colorStaticBase
        case .type2: UIImage.colorStaticTint
        case .type3: UIImage.colorStaticMixed
        case .type4: UIImage.colorStaticShade
        default: nil
        }
    }
}


 
