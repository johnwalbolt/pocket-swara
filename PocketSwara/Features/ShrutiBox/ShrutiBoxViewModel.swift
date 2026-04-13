import Foundation

@Observable
class ShrutiBoxViewModel {
    var activeSwaras: Set<Swara> = []
    var volumes: [Swara: Float] = [:]

    private var synthesizers: [Swara: ShrutiBoxSynthesizer] = [:]

    func toggleSwara(_ swara: Swara, baseSaFrequency: Float) {
        if activeSwaras.contains(swara) {
            deactivateSwara(swara)
        } else {
            activateSwara(swara, baseSaFrequency: baseSaFrequency)
        }
    }

    func activateSwara(_ swara: Swara, baseSaFrequency: Float) {
        let freq = swara.frequency(baseSaFrequency: baseSaFrequency)
        let synth = ShrutiBoxSynthesizer(frequency: freq)
        synth.setAmplitude(volumes[swara] ?? 0.7)
        synth.start()
        AudioEngine.shared.connect(node: synth.sourceNode)
        synthesizers[swara] = synth
        activeSwaras.insert(swara)
        if volumes[swara] == nil {
            volumes[swara] = 0.7
        }
    }

    func deactivateSwara(_ swara: Swara) {
        if let synth = synthesizers[swara] {
            AudioEngine.shared.disconnect(node: synth.sourceNode)
            synth.stop()
        }
        synthesizers.removeValue(forKey: swara)
        activeSwaras.remove(swara)
    }

    func setVolume(_ volume: Float, for swara: Swara) {
        volumes[swara] = volume
        synthesizers[swara]?.setAmplitude(volume)
    }

    func stopAll() {
        for swara in activeSwaras {
            deactivateSwara(swara)
        }
    }
}
