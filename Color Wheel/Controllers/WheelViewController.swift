import UIKit

enum WheelType: Int, CaseIterable {
    
    case type1, type2, type3, type4, type5
}

enum StaticWheelType: Int, CaseIterable {
    
    case type1, type2, type3, type4
}

final class WheelViewController: UIViewController {
    
    private let wheelType: WheelType
    
    private let staticWheel = ColorWheel()
    private let rotatingWheel: RotatingWheel
    private let titleLabel = UILabel()
    private let hintButton = UIButton()
    private let changeWheel = UIImageView()

    
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
    
    @objc func changeWheelTapped() {
        print("Image was tapped!")
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
        
        hintButton.setTitle("Hint", for: .normal)
        hintButton.setTitleColor(.white, for: .normal)
        hintButton.backgroundColor = UIColor(red: 218/255, green: 112/255, blue: 214/255, alpha: 1)
        hintButton.layer.cornerRadius = 10
        hintButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hintButton)
        hintButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        hintButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        hintButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        hintButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(changeWheel)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeWheelTapped))
        changeWheel.isUserInteractionEnabled = true
        changeWheel.addGestureRecognizer(tapGesture)
        changeWheel.image = UIImage(named: "changeColorWheel")
        
        changeWheel.translatesAutoresizingMaskIntoConstraints = false
        // Відступи від лівого краю
        changeWheel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        // Відступи від верхнього краю
        changeWheel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        // Ширина
        changeWheel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        // Висота
        changeWheel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}

