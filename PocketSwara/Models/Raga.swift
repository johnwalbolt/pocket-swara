import Foundation

struct Raga: Identifiable, Hashable {
    let id: String
    let name: String
    let alternateNames: [String]
    let thaat: String
    let aroh: [Swara]
    let avroh: [Swara]
    let vadi: Swara
    let samvadi: Swara
    let timeOfDay: String
    let description: String

    var swaras: Set<Swara> {
        var set = Set<Swara>()
        for s in aroh { set.insert(s) }
        for s in avroh { set.insert(s) }
        return set
    }

    var arohDisplay: String {
        aroh.map { $0.shortName }.joined(separator: " ")
    }

    var avrohDisplay: String {
        avroh.map { $0.shortName }.joined(separator: " ")
    }
}
