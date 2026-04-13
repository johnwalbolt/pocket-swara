import SwiftUI

@Observable
class AppState {
    var baseSaPitch: NotePitch = NotePitch.defaultSa
    var selectedRaga: Raga? = nil

    var baseSaFrequency: Float {
        baseSaPitch.frequency
    }

    var activeSwaras: Set<Swara> {
        if let raga = selectedRaga {
            return raga.swaras
        }
        return Set(Swara.allCases)
    }
}
