import UIKit

enum WheelType: Int, CaseIterable {
    
    case analog, tab2, tab3, tab4, tab5
}

final class WheelViewController: UIViewController {
    
    private let wheelType: WheelType
    
    private let staticWheel = ColorWheel()
    private let rotatingWheel: RotatingWheel
    private let titleLabel = UILabel()
    
    init(wheelType: WheelType) {
        self.wheelType = wheelType
        rotatingWheel = .init(wheelType: wheelType)
        titleLabel.text = wheelType.tabItemTitle
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(staticWheel)
        staticWheel.translatesAutoresizingMaskIntoConstraints = false
        staticWheel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        staticWheel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        staticWheel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        staticWheel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        staticWheel.heightAnchor.constraint(equalTo: staticWheel.widthAnchor).isActive = true
        
        view.addSubview(rotatingWheel)
        rotatingWheel.translatesAutoresizingMaskIntoConstraints = false
        rotatingWheel.leadingAnchor.constraint(equalTo: staticWheel.leadingAnchor).isActive = true
        rotatingWheel.trailingAnchor.constraint(equalTo: staticWheel.trailingAnchor).isActive = true
        rotatingWheel.topAnchor.constraint(equalTo: staticWheel.topAnchor).isActive = true
        rotatingWheel.bottomAnchor.constraint(equalTo: staticWheel.bottomAnchor).isActive = true
        
        titleLabel.font = .systemFont(ofSize: 14)
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
