import UIKit

class ColorWheel: UIImageView {

    init() {
        let wheelImage = UIImage(named: "ColorStaticBase")
        super.init(image: wheelImage)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
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
