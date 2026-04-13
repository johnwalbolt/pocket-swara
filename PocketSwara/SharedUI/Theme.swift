import SwiftUI

struct Theme {
    // Per-feature accent colors
    static let tanpuraColor   = Color(red: 1.0, green: 0.42, blue: 0.21)     // warm orange #FF6B35
    static let shrutiBoxColor = Color(red: 0.48, green: 0.18, blue: 0.56)    // deep purple #7B2D8E
    static let harmoniumColor = Color(red: 0.90, green: 0.22, blue: 0.27)    // vibrant red #E63946
    static let referenceColor = Color(red: 0.16, green: 0.62, blue: 0.56)    // teal green #2A9D8F
    static let tunerColor     = Color(red: 0.15, green: 0.27, blue: 0.33)    // dark teal #264653
    static let ragaColor      = Color(red: 0.91, green: 0.77, blue: 0.42)    // golden yellow #E9C46A
    static let settingsColor  = Color(red: 0.55, green: 0.55, blue: 0.58)    // neutral gray

    // Background
    static let backgroundColor = Color(red: 1.0, green: 0.97, blue: 0.94)    // warm off-white #FFF8F0
    static let cardBackground  = Color.white

    // Layout
    static let cornerRadius: CGFloat = 16
    static let cardCornerRadius: CGFloat = 12
    static let smallCornerRadius: CGFloat = 8

    // Fonts
    static let titleFont = Font.system(.title2, design: .rounded, weight: .bold)
    static let headlineFont = Font.system(.headline, design: .rounded, weight: .semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)

    // Swara colors (for the 12 swaras)
    static func swaraColor(for swara: Swara) -> Color {
        switch swara {
        case .sa:       return Color(red: 1.0, green: 0.35, blue: 0.35)   // red
        case .reKomal:  return Color(red: 1.0, green: 0.55, blue: 0.25)   // dark orange
        case .re:       return Color(red: 1.0, green: 0.65, blue: 0.15)   // orange
        case .gaKomal:  return Color(red: 0.95, green: 0.80, blue: 0.15)  // yellow-orange
        case .ga:       return Color(red: 0.85, green: 0.90, blue: 0.15)  // yellow-green
        case .ma:       return Color(red: 0.30, green: 0.80, blue: 0.35)  // green
        case .maTivra:  return Color(red: 0.15, green: 0.75, blue: 0.60)  // teal
        case .pa:       return Color(red: 0.20, green: 0.65, blue: 0.85)  // blue
        case .dhaKomal: return Color(red: 0.35, green: 0.45, blue: 0.85)  // indigo
        case .dha:      return Color(red: 0.55, green: 0.35, blue: 0.85)  // purple
        case .niKomal:  return Color(red: 0.75, green: 0.30, blue: 0.75)  // magenta
        case .ni:       return Color(red: 0.90, green: 0.30, blue: 0.55)  // pink
        }
    }
}
