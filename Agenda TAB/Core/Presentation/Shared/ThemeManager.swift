import SwiftUI
import Combine

enum ThemeMode: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case system = "system"
    
    var localizedName: String {
        switch self {
        case .light: return NSLocalizedString("light_theme", comment: "")
        case .dark: return NSLocalizedString("dark_theme", comment: "")
        case .system: return NSLocalizedString("system_theme", comment: "")
        }
    }
}

class ThemeManager: ObservableObject {
    @Published var themeMode: ThemeMode = .system
    
    private let userDefaults = UserDefaults.standard
    private let themeKey = "theme_mode"
    
    init() {
        loadTheme()
    }
    
    func setTheme(_ mode: ThemeMode) {
        themeMode = mode
        userDefaults.set(mode.rawValue, forKey: themeKey)
    }
    
    private func loadTheme() {
        if let savedTheme = userDefaults.string(forKey: themeKey),
           let mode = ThemeMode(rawValue: savedTheme) {
            themeMode = mode
        }
    }
    
    var colorScheme: ColorScheme? {
        switch themeMode {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}
