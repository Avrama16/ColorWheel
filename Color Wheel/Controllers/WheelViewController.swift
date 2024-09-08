import UIKit

enum WheelType: Int, CaseIterable {
    
    case type1, type2, type3, type4, type5
}

enum StaticWheelType: Int, CaseIterable {
    
    case type1, type2, type3, type4
}

final class WheelViewController: UIViewController {
    
    var currentWheelState: StaticWheelType = .type1 {
        didSet {
            //updateWheelState()
        }
    }
    
    private let wheelType: WheelType
    private let staticWheel = ColorWheel()
    private let rotatingWheel: RotatingWheel
    private let titleLabel = UILabel()
    private let hintButton = UIButton()
    private let changeWheel = UIImageView()
    
    let popupView = UIView()
    let okButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)
    let backgroundView = UIView()
    
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
        
    }
    
    @objc func showHint() {
        // Налаштування головного pop-up вікна
        popupView.frame = CGRect(x: 20, y: view.frame.height, width: view.frame.width - 40, height: 250)
        popupView.backgroundColor = .white
        popupView.layer.cornerRadius = 10
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 0.3
        popupView.layer.shadowOffset = CGSize(width: 0, height: 5)
        popupView.layer.shadowRadius = 10
        view.addSubview(popupView)
        backgroundView.addSubview(popupView)
        
        
        backgroundView.frame = view.bounds
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(backgroundView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closePopup))
        backgroundView.addGestureRecognizer(tapGesture)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 10, width: popupView.frame.width, height: 30))
        titleLabel.text = wheelType.tabItemTitle
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        popupView.addSubview(titleLabel)
        
        let messageLabel = UILabel(frame: CGRect(x: 20, y: 50, width: popupView.frame.width - 40, height: 100))
        messageLabel.text = "An analogous color scheme is based on using colors that are next to each other on the color wheel. Analogous colors can look even more interesting when various textures are added. Use accessories in analogous colors for accents. These could be bags, scarves, or jewelry that complement your look and add a finishing touch."
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        popupView.addSubview(messageLabel)
        
        okButton.setTitle("OK", for: .normal)
        okButton.backgroundColor = .systemBlue
        okButton.setTitleColor(.white, for: .normal)
        okButton.layer.cornerRadius = 10
        okButton.frame = CGRect(x: 20, y: popupView.frame.height - 70, width: popupView.frame.width - 40, height: 50)
        okButton.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
        popupView.addSubview(okButton)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.popupView.frame.origin.y = self.view.frame.height / 2 - 125
        })
    }
    
    @objc func closePopup() {
        UIView.animate(withDuration: 0.3, animations: {
            self.popupView.frame.origin.y = self.view.frame.height
        }, completion: { _ in
            self.backgroundView.removeFromSuperview()
        })
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
        titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        hintButton.setTitle("Hint", for: .normal)
        hintButton.addTarget(self, action: #selector(showHint), for: .touchUpInside)
        hintButton.setTitleColor(.white, for: .normal)
        hintButton.backgroundColor = .systemBlue
        hintButton.layer.cornerRadius = 10
        hintButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hintButton)
        hintButton.topAnchor.constraint(equalTo: staticWheel.bottomAnchor, constant: 40).isActive = true
        hintButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        hintButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        hintButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(changeWheel)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeWheelTapped))
        changeWheel.isUserInteractionEnabled = true
        changeWheel.addGestureRecognizer(tapGesture)
        changeWheel.image = UIImage(named: "changeColorWheel")
        
        changeWheel.translatesAutoresizingMaskIntoConstraints = false
        // Відступи від лівого краю
        changeWheel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        // Відступи від верхнього краю
        changeWheel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -30).isActive = true
        // Ширина
        changeWheel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        // Висота
        changeWheel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    //    func updateWheelState() {
    //        wheelImage.image = currentWheelState.staticWheelType
    //        }
}

