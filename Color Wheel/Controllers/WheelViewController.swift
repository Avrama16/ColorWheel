import UIKit

// Синглтон для управління станом колеса
final class WheelStateManager {
    static let shared = WheelStateManager()
    
    private init() {}
    
    var currentStaticWheelType: StaticWheelType {
        get {
            let rawValue = UserDefaults.standard.integer(forKey: "StaticWheelTypeState")
            return StaticWheelType(rawValue: rawValue) ?? .type1
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "StaticWheelTypeState")
            NotificationCenter.default.post(name: .staticWheelTypeDidChange, object: newValue)
        }
    }
}

extension Notification.Name {
    static let staticWheelTypeDidChange = Notification.Name("staticWheelTypeDidChange")
}

enum WheelType: Int, CaseIterable {
    case type2 // Complementary
    case type4 // Tetradic
    case type1 // Analogous
    case type5 // Split-Complementary
    case type3 // Triadic
}

enum StaticWheelType: Int, CaseIterable {
    case type1, type2, type3, type4
}

extension StaticWheelType {
    var staticWheelType: UIImage? {
        switch self {
        case .type1: return UIImage(named: "ColorStaticBase")
        case .type2: return UIImage(named: "ColorStaticTint")
        case .type3: return UIImage(named: "ColorStaticMixed")
        case .type4: return UIImage(named: "ColorStaticShade")
        }
    }
}

final class WheelViewController: UIViewController {
    
    var currentWheelState: StaticWheelType = .type1 {
        didSet {
            staticWheel.image = currentWheelState.staticWheelType
            print("WheelViewController: Updated static wheel type to \(currentWheelState)")
        }
    }
    
    private var wheelType: WheelType
    private let staticWheel = ColorWheel()
    private let rotatingWheel: RotatingWheel
    private let titleLabel = UILabel()
    private let hintButton = UIButton()
    private let changeWheel = UIButton()
    
    let popupView = UIView()
    let okButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)
    let backgroundView = UIView()
    
    init(wheelType: WheelType) {
        self.wheelType = wheelType
        rotatingWheel = .init(wheelType: wheelType)
        titleLabel.text = wheelType.tabItemTitle
        
        super.init(nibName: nil, bundle: nil)
        
        // Завантажуємо збережений стан
        if let tabBarController = self.tabBarController as? CustomTabBarController {
            self.currentWheelState = tabBarController.currentStaticWheelType
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        // Додаємо спостерігач за зміною типу колеса
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(staticWheelTypeDidChange(_:)),
            name: .staticWheelTypeDidChange,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func staticWheelTypeDidChange(_ notification: Notification) {
        if let newType = notification.object as? StaticWheelType {
            currentWheelState = newType
        }
    }
    
    // Метод для оновлення типу колеса ззовні
    func updateWheelType(_ type: StaticWheelType) {
        currentWheelState = type
    }
    
    @objc 
    private func changeWheelTapped() {
        if let currentIndex = StaticWheelType.allCases.firstIndex(of: currentWheelState) {
            let nextIndex = (currentIndex + 1) % StaticWheelType.allCases.count
            let newType = StaticWheelType.allCases[nextIndex]
            
            // Оновлюємо стан через TabBarController
            if let tabBarController = self.tabBarController as? CustomTabBarController {
                tabBarController.currentStaticWheelType = newType
            }
        }
        print("WheelViewController: Static wheel type changed to \(currentWheelState)")
    }
    
    @objc func showHint() {
        // Налаштування головного pop-up вікна
        let popupWidth: CGFloat = 368
        let popupHeight: CGFloat = 380
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height
        
        // Розрахунок позиції для центрування попапу
        let xPosition = (screenWidth - popupWidth) / 2
        let yPosition = (screenHeight - popupHeight) / 2
        
        // Налаштування фону
        backgroundView.frame = view.bounds
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(backgroundView)
        
        // Налаштування попапу
        popupView.frame = CGRect(x: xPosition, y: screenHeight, width: popupWidth, height: popupHeight)
        popupView.backgroundColor = .white
        popupView.layer.cornerRadius = 24
        popupView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 0.3
        popupView.layer.shadowOffset = CGSize(width: 0, height: 5)
        popupView.layer.shadowRadius = 10
        backgroundView.addSubview(popupView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closePopup))
        backgroundView.addGestureRecognizer(tapGesture)
        
        // Додаємо зображення з таббару (збільшуємо відстань від верхнього краю)
        let tabImageView = UIImageView(frame: CGRect(x: 0, y: 20, width: popupWidth, height: 80))
        tabImageView.contentMode = .scaleAspectFit
        tabImageView.image = wheelType.tabItemImage
        tabImageView.backgroundColor = .white
        tabImageView.layer.cornerRadius = 24
        tabImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        popupView.addSubview(tabImageView)
        
        // Налаштування заголовка (збільшуємо відстань)
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 110, width: popupWidth, height: 30))
        titleLabel.text = wheelType.tabItemTitle
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        popupView.addSubview(titleLabel)
        
        // Створюємо футер для тексту (збільшуємо розмір)
        let footerHeight: CGFloat = 120
        let footerView = UIView(frame: CGRect(x: 0, y: 150, width: popupWidth, height: footerHeight))
        footerView.backgroundColor = .white
        popupView.addSubview(footerView)
        
        // Створюємо скролв'ю для тексту всередині футера
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: popupWidth, height: footerHeight))
        scrollView.showsVerticalScrollIndicator = true
        footerView.addSubview(scrollView)
        
        // Налаштування тексту повідомлення (збільшуємо розмір шрифту)
        let messageLabel = UILabel(frame: CGRect(x: 20, y: 0, width: popupWidth - 40, height: 0))
        messageLabel.text = "An analogous color scheme is based on using colors that are next to each other on the color wheel. Analogous colors can look even more interesting when various textures are added. Use accessories in analogous colors for accents."
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        
        // Розраховуємо розмір тексту
        let maxSize = CGSize(width: popupWidth - 40, height: .greatestFiniteMagnitude)
        let textSize = messageLabel.sizeThatFits(maxSize)
        messageLabel.frame.size.height = textSize.height
        
        scrollView.addSubview(messageLabel)
        scrollView.contentSize = CGSize(width: popupWidth, height: textSize.height)
        
        // Налаштування кнопки OK (робимо темно-синьою з контрастним текстом)
        okButton.setTitle("Ok, got it", for: .normal)
        okButton.backgroundColor = .systemIndigo
        okButton.setTitleColor(.white, for: .normal)
        okButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        okButton.layer.cornerRadius = 10
        okButton.frame = CGRect(x: 20, y: popupHeight - 60, width: popupWidth - 40, height: 40)
        okButton.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
        popupView.addSubview(okButton)
        
        // Анімація появи попапу
        UIView.animate(withDuration: 0.3, animations: {
            self.popupView.frame.origin.y = yPosition
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
        print("WheelViewController: Setting up layout")
        
        // Спочатку додаємо staticWheel
        staticWheel.isUserInteractionEnabled = false
        print("WheelViewController: Static wheel - isUserInteractionEnabled: \(staticWheel.isUserInteractionEnabled)")
        view.addSubview(staticWheel)
        staticWheel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            staticWheel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            staticWheel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            staticWheel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            staticWheel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            staticWheel.heightAnchor.constraint(equalTo: staticWheel.widthAnchor)
        ])
        print("WheelViewController: Static wheel added to view hierarchy")
        
        // Потім додаємо rotatingWheel поверх staticWheel
        rotatingWheel.isUserInteractionEnabled = true
        print("WheelViewController: Rotating wheel - isUserInteractionEnabled: \(rotatingWheel.isUserInteractionEnabled)")
        view.addSubview(rotatingWheel)
        rotatingWheel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rotatingWheel.leadingAnchor.constraint(equalTo: staticWheel.leadingAnchor),
            rotatingWheel.trailingAnchor.constraint(equalTo: staticWheel.trailingAnchor),
            rotatingWheel.topAnchor.constraint(equalTo: staticWheel.topAnchor),
            rotatingWheel.bottomAnchor.constraint(equalTo: staticWheel.bottomAnchor)
        ])
        print("WheelViewController: Rotating wheel added to view hierarchy")
        
        // Налаштування titleLabel
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .darkGray
        titleLabel.backgroundColor = .white
        titleLabel.layer.cornerRadius = 10
        titleLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        titleLabel.layer.borderWidth = 0.5
        titleLabel.layer.borderColor = UIColor.lightGray.cgColor
        titleLabel.textAlignment = .center
        titleLabel.clipsToBounds = true
        
        // Додаємо відступи для тексту
        titleLabel.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        // Встановлюємо фіксовану ширину для найдовшого тексту
        let longestText = "Split-Complementary color scheme"
        let size = (longestText as NSString).size(withAttributes: [.font: titleLabel.font!])
        let width = size.width + 20 // Додаємо відступи
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: width),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Налаштування hintButton
        hintButton.setTitle("Hint", for: .normal)
        hintButton.addTarget(self, action: #selector(showHint), for: .touchUpInside)
        hintButton.setTitleColor(.white, for: .normal)
        hintButton.backgroundColor = .systemIndigo
        hintButton.layer.cornerRadius = 10
        hintButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hintButton)
        NSLayoutConstraint.activate([
            hintButton.topAnchor.constraint(equalTo: staticWheel.bottomAnchor, constant: 40),
            hintButton.widthAnchor.constraint(equalToConstant: 100),
            hintButton.heightAnchor.constraint(equalToConstant: 40),
            hintButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Налаштування changeWheel
        changeWheel.setImage(.changeColorWheel, for: [])
        changeWheel.addTarget(self, action: #selector(changeWheelTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = .init(customView: changeWheel)
        
        print("WheelViewController: Layout setup completed")
    }
    
    @objc 
    private func showLanguageSelection() {
        let languageSelectionVC = LanguageSelectionViewController()
        navigationController?.pushViewController(languageSelectionVC, animated: true)
    }
}

