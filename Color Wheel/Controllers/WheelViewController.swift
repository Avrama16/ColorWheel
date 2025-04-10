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

extension WheelType {
    var tabItemTitle: String {
        switch self {
        case .type1:
            return NSLocalizedString("Analogous scheme", comment: "Title for Analogous color scheme")
        case .type2:
            return NSLocalizedString("Complementary scheme", comment: "Title for Complementary color scheme")
        case .type3:
            return NSLocalizedString("Triadic scheme", comment: "Title for Triadic color scheme")
        case .type4:
            return NSLocalizedString("Tetradic scheme", comment: "Title for Tetradic color scheme")
        case .type5:
            return NSLocalizedString("Split Complementary scheme", comment: "Title for Split-Complementary color scheme")
        }
    }
    
    var tabItemImage: UIImage? {
        return switch self {
        case .type2: UIImage.compBar
        case .type3: UIImage.triadBar
        case .type1: UIImage.analogBar
        case .type5: UIImage.splitCompBar
        case .type4: UIImage.tetradBar
        }
    }
}

final class WheelViewController: UIViewController {
    
    var currentWheelState: StaticWheelType = .type1 {
        didSet {
            staticWheel.image = currentWheelState.staticWheelType
        }
    }
    
    private var wheelType: WheelType
    private let staticWheel = ColorWheel()
    private let rotatingWheel: RotatingWheel
    private let titleLabel = UILabel()
    private let hintButton = UIButton()
    private var changeWheel = UIButton()
    
    // Власний навігаційний бар
    private let customNavigationBar = UIView()
    private let changeWheelButton = UIButton(type: .custom)
    private let infoButton = UIButton(type: .custom)
    
    var popupView = UIView()
    var okButton = UIButton(type: .system)
    var closeButton = UIButton(type: .system)
    var backgroundView = UIView()
    
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
        
        // Приховуємо стандартний навігаційний бар
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Налаштування власного навігаційного бару
        setupCustomNavigationBar()
        
        setupLayout()
        
        // Додаємо спостерігач за зміною типу колеса
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(staticWheelTypeDidChange(_:)),
            name: .staticWheelTypeDidChange,
            object: nil
        )
    }
    
    private func setupCustomNavigationBar() {
        // Налаштування власного навігаційного бару
        customNavigationBar.backgroundColor = .white
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customNavigationBar)
        
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Налаштування кнопки changeWheel
        changeWheelButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        changeWheelButton.setImage(.changeColorWheel, for: .normal)
        changeWheelButton.addTarget(self, action: #selector(changeWheelTapped), for: .touchUpInside)
        changeWheelButton.translatesAutoresizingMaskIntoConstraints = false
        customNavigationBar.addSubview(changeWheelButton)
        
        NSLayoutConstraint.activate([
            changeWheelButton.leadingAnchor.constraint(equalTo: customNavigationBar.leadingAnchor, constant: 16),
            changeWheelButton.centerYAnchor.constraint(equalTo: customNavigationBar.centerYAnchor),
            changeWheelButton.widthAnchor.constraint(equalToConstant: 30),
            changeWheelButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Налаштування кнопки Info
        infoButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let infoImage = UIImage(systemName: "info.circle")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        )
        infoButton.setImage(infoImage, for: .normal)
        infoButton.tintColor = UIColor(red: 74/255, green: 91/255, blue: 57/255, alpha: 1.0)
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        customNavigationBar.addSubview(infoButton)
        
        NSLayoutConstraint.activate([
            infoButton.trailingAnchor.constraint(equalTo: customNavigationBar.trailingAnchor, constant: -16),
            infoButton.centerYAnchor.constraint(equalTo: customNavigationBar.centerYAnchor),
            infoButton.widthAnchor.constraint(equalToConstant: 40),
            infoButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Приховуємо стандартний навігаційний бар
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        // Налаштування статичного колеса
        staticWheel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(staticWheel)
        NSLayoutConstraint.activate([
            staticWheel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            staticWheel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            staticWheel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            staticWheel.heightAnchor.constraint(equalTo: staticWheel.widthAnchor)
        ])
        
        // Налаштування обертаючогося колеса
        rotatingWheel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rotatingWheel)
        NSLayoutConstraint.activate([
            rotatingWheel.centerXAnchor.constraint(equalTo: staticWheel.centerXAnchor),
            rotatingWheel.centerYAnchor.constraint(equalTo: staticWheel.centerYAnchor),
            rotatingWheel.widthAnchor.constraint(equalTo: staticWheel.widthAnchor),
            rotatingWheel.heightAnchor.constraint(equalTo: staticWheel.heightAnchor)
        ])
        
        // Налаштування кнопки Hint
        hintButton.translatesAutoresizingMaskIntoConstraints = false
        hintButton.setTitle(NSLocalizedString("Hint", comment: ""), for: .normal)
        hintButton.addTarget(self, action: #selector(showHint), for: .touchUpInside)
        hintButton.setTitleColor(.white, for: .normal)
        hintButton.backgroundColor = UIColor(red: 74/255, green: 91/255, blue: 57/255, alpha: 1.0)
        if let customFont = UIFont(name: "GT-Eesti-Text-Bold-Trial", size: 16) {
            hintButton.titleLabel?.font = customFont
        } else {
            print("WheelViewController: Failed to load GT-Eesti-Text-Bold-Trial font, using system font")
            hintButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        }
        hintButton.layer.cornerRadius = 27
        view.addSubview(hintButton)
        NSLayoutConstraint.activate([
            hintButton.topAnchor.constraint(equalTo: staticWheel.bottomAnchor, constant: 40),
            hintButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hintButton.widthAnchor.constraint(equalToConstant: 200),
            hintButton.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        // Налаштування заголовка
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        if let customFont = UIFont(name: "GT-Eesti-Text-Regular-Trial", size: 14) {
            titleLabel.font = customFont
        } else {
            titleLabel.font = .systemFont(ofSize: 14)
        }
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
        let size = (longestText as NSString).size(withAttributes: [.font: titleLabel.font as Any])
        let width = size.width + 20 // Додаємо відступи
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: width),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
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
        // Check if the popup is already open
        if popupView.superview != nil {
            return
        }
        
        // Create new instances for each popup opening
        let popupView = UIView()
        let backgroundView = UIView()
        let okButton = UIButton(type: .system)
        
        // Main popup setup
        let popupWidth: CGFloat = 368
        let popupHeight: CGFloat = 480
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height
        
        // Calculate position for centering the popup
        let xPosition = (screenWidth - popupWidth) / 2
        let yPosition = (screenHeight - popupHeight) / 2
        
        // Background setup
        backgroundView.frame = view.bounds
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(backgroundView)
        
        // Popup setup
        popupView.frame = CGRect(x: xPosition, y: screenHeight, width: popupWidth, height: popupHeight)
        popupView.backgroundColor = .white
        popupView.layer.cornerRadius = 24
        popupView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 0.3
        popupView.layer.shadowOffset = CGSize(width: 0, height: 5)
        popupView.layer.shadowRadius = 10
        backgroundView.addSubview(popupView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closePopup(_:)))
        backgroundView.addGestureRecognizer(tapGesture)
        
        // Add tab image from tab bar
        let tabImageView = UIImageView(frame: CGRect(x: 0, y: 20, width: popupWidth, height: 80))
        tabImageView.contentMode = .scaleAspectFit
        tabImageView.image = wheelType.tabItemImage
        tabImageView.backgroundColor = .white
        tabImageView.layer.cornerRadius = 24
        tabImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        popupView.addSubview(tabImageView)
        
        // Title setup
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 110, width: popupWidth, height: 30))
        titleLabel.text = wheelType.tabItemTitle
        titleLabel.textAlignment = .center
        if let customFont = UIFont(name: "GT-Eesti-Text-Bold-Trial", size: 14) {
            titleLabel.font = customFont
        } else {
            titleLabel.font = .boldSystemFont(ofSize: 14)
        }
        titleLabel.textColor = .darkGray
        popupView.addSubview(titleLabel)
        
        // Add hint text
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: popupWidth - 40, height: 0))
        messageLabel.text = getHintText(for: wheelType)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        if let customFont = UIFont(name: "GT-Eesti-Text-Regular-Trial", size: 16) {
            messageLabel.font = customFont
        } else {
            messageLabel.font = .systemFont(ofSize: 16)
        }
        messageLabel.textColor = .darkGray
        
        // Calculate text size
        messageLabel.sizeToFit()
        
        // Set a fixed height for the scroll view inside the footer
        let lineHeight: CGFloat = messageLabel.font.lineHeight
        let footerHeight: CGFloat = lineHeight * 8.5
        let spacing: CGFloat = 20
        let scrollView = UIScrollView(frame: CGRect(x: 20, y: titleLabel.frame.maxY + spacing, width: popupWidth - 40, height: popupHeight - titleLabel.frame.maxY - spacing * 3 - 70))
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentSize = CGSize(width: popupWidth - 40, height: messageLabel.frame.height)
        messageLabel.frame.origin = .zero
        scrollView.addSubview(messageLabel)
        popupView.addSubview(scrollView)
        
        // Update OK button position
        okButton.frame = CGRect(x: 20, y: popupHeight - 70, width: popupWidth - 40, height: 50)
        okButton.center.x = popupView.frame.width / 2
        okButton.setTitle(NSLocalizedString("Ok. got it", comment: ""), for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.backgroundColor = UIColor(red: 74/255, green: 91/255, blue: 57/255, alpha: 1.0)
        if let customFont = UIFont(name: "GT-Eesti-Text-Bold-Trial", size: 16) {
            okButton.titleLabel?.font = customFont
        } else {
            okButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        }
        okButton.layer.cornerRadius = 25
        okButton.addTarget(self, action: #selector(closePopup(_:)), for: .touchUpInside)
        popupView.addSubview(okButton)
        
        // Store references for closing
        self.popupView = popupView
        self.backgroundView = backgroundView
        
        // Bring views to the front
        view.bringSubviewToFront(backgroundView)
        view.bringSubviewToFront(popupView)
        
        // Animate the popup to move upwards to its final position
        UIView.animate(withDuration: 0.3) {
            popupView.frame.origin.y = yPosition
        }
    }
    
    private func getHintText(for wheelType: WheelType) -> String {
        switch wheelType {
        case .type1:
            return NSLocalizedString("Analogous color scheme consists of colors that are adjacent to each other on the color wheel. These colors create a harmonious and cohesive look. Perfect for creating a unified and soothing design. Great for backgrounds, nature-inspired designs, and when you want to convey a sense of harmony and tranquility. Try using these combinations for interior design, fashion, or creating a calming atmosphere in your artwork.", comment: "")
        case .type2:
            return NSLocalizedString("Complementary color scheme uses colors that are opposite each other on the color wheel. This creates a high contrast and vibrant look. The strong contrast makes both colors appear more intense and creates a dynamic visual impact. Ideal for creating bold statements, highlighting important elements, or adding energy to your design. Perfect for call-to-action buttons, sports branding, or when you want to create a dramatic effect in your artwork.", comment: "")
        case .type3:
            return NSLocalizedString("Triadic color scheme uses three colors that are evenly spaced around the color wheel. This creates a balanced and dynamic look. The three colors form a triangle on the color wheel, offering a rich and diverse palette while maintaining harmony. Great for creating vibrant and energetic designs. Perfect for children's products, playful branding, or when you want to create a fun and lively atmosphere. Try using one color as the dominant shade and the others as accents.", comment: "")
        case .type4:
            return NSLocalizedString("Tetradic color scheme uses four colors that form a rectangle on the color wheel. This creates a rich and complex color palette. The four colors offer endless possibilities for creating sophisticated and layered designs. Excellent for creating depth and visual interest in your work. Perfect for complex designs, detailed illustrations, or when you want to create a rich and luxurious feel. Remember to balance the colors by using one as the dominant shade and the others as supporting elements.", comment: "")
        case .type5:
            return NSLocalizedString("Split-Complementary color scheme uses a base color and two colors adjacent to its complement. This creates a high contrast look while being more versatile than a complementary scheme. The combination offers the energy of complementary colors with more flexibility and harmony. Great for creating dynamic designs that aren't too overwhelming. Perfect for modern branding, web design, or when you want to create an energetic yet balanced composition. Try using the base color as your primary shade and the split-complements as accents.", comment: "")
        }
    }
    
    @objc 
    private func showLanguageSelection() {
        let languageSelectionVC = LanguageSelectionViewController()
        navigationController?.pushViewController(languageSelectionVC, animated: true)
    }
    
    @objc
    private func closePopup(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.popupView.frame.origin.y = self.view.frame.height
            self.backgroundView.alpha = 0
        }) { _ in
            // Видаляємо всі підклади
            for subview in self.popupView.subviews {
                subview.removeFromSuperview()
            }
            
            // Видаляємо самі view
            self.popupView.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
            
            // Скидаємо стан кнопки Hint
            self.hintButton.isEnabled = true
        }
    }
    
    @objc func showInfo() {
        // Check if the popup is already open
        if popupView.superview != nil {
            return
        }
        
        // Create new instances for each popup opening
        let popupView = UIView()
        let backgroundView = UIView()
        let okButton = UIButton(type: .system)
        
        // Main popup setup
        let popupWidth: CGFloat = 368
        let popupHeight: CGFloat = 500
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height
        
        // Calculate position for centering the popup
        let xPosition = (screenWidth - popupWidth) / 2
        let yPosition = (screenHeight - popupHeight) / 2
        
        // Background setup
        backgroundView.frame = view.bounds
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(backgroundView)
        
        // Popup setup
        popupView.frame = CGRect(x: xPosition, y: screenHeight, width: popupWidth, height: popupHeight)
        popupView.backgroundColor = .white
        popupView.layer.cornerRadius = 24
        popupView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 0.3
        popupView.layer.shadowOffset = CGSize(width: 0, height: 5)
        popupView.layer.shadowRadius = 10
        backgroundView.addSubview(popupView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeInfoPopup(_:)))
        backgroundView.addGestureRecognizer(tapGesture)
        
        // Add Info icon
        let infoImageView = UIImageView(frame: CGRect(x: 0, y: 20, width: popupWidth, height: 80))
        infoImageView.contentMode = .scaleAspectFit
        infoImageView.image = UIImage(systemName: "info.circle.fill")
        infoImageView.tintColor = UIColor(red: 74/255, green: 91/255, blue: 57/255, alpha: 1.0)
        infoImageView.backgroundColor = .white
        infoImageView.layer.cornerRadius = 24
        infoImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        popupView.addSubview(infoImageView)
        
        // Title setup
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 110, width: popupWidth, height: 30))
        titleLabel.text = NSLocalizedString("info_popup_title", comment: "")
        titleLabel.textAlignment = .center
        if let customFont = UIFont(name: "GT-Eesti-Text-Bold-Trial", size: 14) {
            titleLabel.font = customFont
        } else {
            titleLabel.font = .boldSystemFont(ofSize: 14)
        }
        titleLabel.textColor = .darkGray
        popupView.addSubview(titleLabel)
        
        // Add Info text
        let scrollView = UIScrollView(frame: CGRect(x: 20, y: titleLabel.frame.maxY + 40, width: popupWidth - 40, height: popupHeight - titleLabel.frame.maxY - 40 - 40 - 60))
        scrollView.showsVerticalScrollIndicator = true
        popupView.addSubview(scrollView)
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: popupWidth - 40, height: 0))
        messageLabel.text = NSLocalizedString("info_popup_message", comment: "")
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        if let customFont = UIFont(name: "GT-Eesti-Text-Regular-Trial", size: 16) {
            messageLabel.font = customFont
        } else {
            messageLabel.font = .systemFont(ofSize: 16)
        }
        messageLabel.textColor = .darkGray
        
        // Calculate text size
        messageLabel.sizeToFit()
        scrollView.contentSize = CGSize(width: popupWidth - 40, height: messageLabel.frame.height)
        scrollView.addSubview(messageLabel)
        
        // OK button setup
        okButton.frame = CGRect(x: 20, y: popupHeight - 60, width: popupWidth - 40, height: 50)
        okButton.setTitle(NSLocalizedString("Let's try", comment: ""), for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.backgroundColor = UIColor(red: 74/255, green: 91/255, blue: 57/255, alpha: 1.0)
        if let customFont = UIFont(name: "GT-Eesti-Text-Bold-Trial", size: 16) {
            okButton.titleLabel?.font = customFont
        } else {
            okButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        }
        okButton.layer.cornerRadius = 25
        okButton.addTarget(self, action: #selector(closeInfoPopup(_:)), for: .touchUpInside)
        popupView.addSubview(okButton)
        
        // Store references for closing
        self.popupView = popupView
        self.backgroundView = backgroundView
        
        // Animate the popup to move upwards to its final position
        UIView.animate(withDuration: 0.3) {
            popupView.frame.origin.y = yPosition
        }
    }
    
    @objc
    private func closeInfoPopup(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.popupView.frame.origin.y = self.view.frame.height
            self.backgroundView.alpha = 0
        }) { _ in
            // Видаляємо всі підклади
            for subview in self.popupView.subviews {
                subview.removeFromSuperview()
            }
            
            // Видаляємо самі view
            self.popupView.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
        }
    }
    
    private func rotateWheel(to angle: CGFloat) {
        // Визначаємо найближчий кут секції
        let numberOfSections = 12
        let sectionAngle = 2 * .pi / CGFloat(numberOfSections)
        let nearestSection = round(angle / sectionAngle) * sectionAngle
        
        // Визначаємо тривалість анімації на основі кута повороту
        let baseDuration = 0.2
        let angleRatio = min(abs(angle - nearestSection) / sectionAngle, 1.0)
        let duration = baseDuration * (0.5 + 0.5 * angleRatio)
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                self.rotatingWheel.transform = CGAffineTransform(rotationAngle: nearestSection)
            }
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Закриваємо попап, якщо він відкритий
        if popupView.superview != nil {
            closePopup(self)
        }
    }
}

