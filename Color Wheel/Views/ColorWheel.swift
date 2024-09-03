import UIKit

class ColorWheel: UIImageView {

    init() {
        let wheelImage = UIImage(named: "ColorWheel.Static.Base")
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
