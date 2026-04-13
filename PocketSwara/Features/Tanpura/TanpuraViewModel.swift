import Foundation

@Observable
class TanpuraViewModel {
    var isPlaying = false
    var droneMode: DroneMode = .saPa
    var pluckRate: Double = 0.6

    private var synthesizer: TanpuraSynthesizer?

    func toggle(baseSaFrequency: Float) {
        if isPlaying {
            stop()
        } else {
            start(baseSaFrequency: baseSaFrequency)
        }
    }

    func start(baseSaFrequency: Float) {
        let synth = TanpuraSynthesizer(
            baseSaFrequency: baseSaFrequency,
            droneMode: droneMode,
            pluckRate: pluckRate
        )
        synth.start()
        AudioEngine.shared.connect(node: synth.sourceNode)
        synthesizer = synth
        isPlaying = true
    }

    func stop() {
        if let synth = synthesizer {
            AudioEngine.shared.disconnect(node: synth.sourceNode)
            synth.stop()
        }
        synthesizer = nil
        isPlaying = false
    }

    func updatePitch(baseSaFrequency: Float) {
        synthesizer?.updateFrequencies(baseSaFrequency: baseSaFrequency, droneMode: droneMode)
    }
}
