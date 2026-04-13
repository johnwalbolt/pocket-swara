import Foundation

enum Swara: Int, CaseIterable, Identifiable, Codable, Hashable {
    case sa = 0
    case reKomal = 1
    case re = 2
    case gaKomal = 3
    case ga = 4
    case ma = 5
    case maTivra = 6
    case pa = 7
    case dhaKomal = 8
    case dha = 9
    case niKomal = 10
    case ni = 11

    var id: Int { rawValue }

    var displayName: String {
        switch self {
        case .sa: return "Sa"
        case .reKomal: return "Re\u{0331}"     // Re with underline (komal indicator)
        case .re: return "Re"
        case .gaKomal: return "Ga\u{0331}"
        case .ga: return "Ga"
        case .ma: return "Ma"
        case .maTivra: return "Ma\u{0301}"      // Ma with accent (tivra indicator)
        case .pa: return "Pa"
        case .dhaKomal: return "Dha\u{0331}"
        case .dha: return "Dha"
        case .niKomal: return "Ni\u{0331}"
        case .ni: return "Ni"
        }
    }

    var shortName: String {
        switch self {
        case .sa: return "S"
        case .reKomal: return "r"
        case .re: return "R"
        case .gaKomal: return "g"
        case .ga: return "G"
        case .ma: return "m"
        case .maTivra: return "M"
        case .pa: return "P"
        case .dhaKomal: return "d"
        case .dha: return "D"
        case .niKomal: return "n"
        case .ni: return "N"
        }
    }

    var labelName: String {
        switch self {
        case .sa: return "Sa"
        case .reKomal: return "Re (Komal)"
        case .re: return "Re"
        case .gaKomal: return "Ga (Komal)"
        case .ga: return "Ga"
        case .ma: return "Ma"
        case .maTivra: return "Ma (Tivra)"
        case .pa: return "Pa"
        case .dhaKomal: return "Dha (Komal)"
        case .dha: return "Dha"
        case .niKomal: return "Ni (Komal)"
        case .ni: return "Ni"
        }
    }

    var semitonesFromSa: Int { rawValue }

    var isKomalOrTivra: Bool {
        switch self {
        case .reKomal, .gaKomal, .maTivra, .dhaKomal, .niKomal: return true
        default: return false
        }
    }

    func frequency(baseSaFrequency: Float, octaveOffset: Int = 0) -> Float {
        baseSaFrequency * powf(2.0, Float(semitonesFromSa + 12 * octaveOffset) / 12.0)
    }
}
