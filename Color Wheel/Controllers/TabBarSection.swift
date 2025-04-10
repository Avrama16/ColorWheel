func tabTitle() -> String {
    switch self {
    case .tab1:
        return NSLocalizedString("Analogous scheme", comment: "")
    case .tab2:
        return NSLocalizedString("Complementary scheme", comment: "")
    case .tab3:
        return NSLocalizedString("Triadic scheme", comment: "")
    case .tab4:
        return NSLocalizedString("Tetradic scheme", comment: "")
    case .tab5:
        return NSLocalizedString("Split Complementary scheme", comment: "")
    }
}

func tabItemTitle() -> String {
    return tabTitle()
} 