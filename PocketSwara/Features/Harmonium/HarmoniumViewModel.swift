import Foundation

@Observable
class HarmoniumViewModel {
    struct KeyID: Hashable {
        let swara: Swara
        let octave: Int
    }

    var pressedKeys: Set<KeyID> = []
    private var synthesizer: HarmoniumSynthesizer?

    init() {
        synthesizer = HarmoniumSynthesizer()
    }

    func keyDown(swara: Swara, octaveOffset: Int, baseSaFrequency: Float) {
        let key = KeyID(swara: swara, octave: octaveOffset)
        guard !pressedKeys.contains(key) else { return }

        pressedKeys.insert(key)
        let freq = swara.frequency(baseSaFrequency: baseSaFrequency, octaveOffset: octaveOffset)

        if let synth = synthesizer {
            if !synth.isPlaying {
                AudioEngine.shared.connect(node: synth.sourceNode)
                synth.start()
            }
            synth.noteOn(frequency: freq)
        }
    }

    func keyUp(swara: Swara, octaveOffset: Int) {
        let key = KeyID(swara: swara, octave: octaveOffset)
        pressedKeys.remove(key)

        if let synth = synthesizer {
            let freq = swara.frequency(baseSaFrequency: 261.63, octaveOffset: octaveOffset)
            synth.noteOff(frequency: freq)

            if pressedKeys.isEmpty {
                // Could keep connected or disconnect after release
            }
        }
    }
}
