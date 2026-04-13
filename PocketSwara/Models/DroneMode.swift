import Foundation

enum DroneMode: String, CaseIterable, Identifiable {
    case saPa = "Sa-Pa"
    case saMa = "Sa-Ma"

    var id: String { rawValue }

    var secondSwara: Swara {
        switch self {
        case .saPa: return .pa
        case .saMa: return .ma
        }
    }
}
