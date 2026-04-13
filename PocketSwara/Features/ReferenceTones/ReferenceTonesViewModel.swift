import Foundation

@Observable
class ReferenceTonesViewModel {
    var currentSwara: Swara? = nil
    private var synthesizer: ReferenceToneSynthesizer?

    func toggleSwara(_ swara: Swara, baseSaFrequency: Float) {
        if currentSwara == swara {
            stopCurrentSwara()
        } else {
            playSwara(swara, baseSaFrequency: baseSaFrequency)
        }
    }

    func playSwara(_ swara: Swara, baseSaFrequency: Float) {
        stopCurrentSwara()

        let freq = swara.frequency(baseSaFrequency: baseSaFrequency)
        let synth = ReferenceToneSynthesizer(frequency: freq)
        synth.start()
        AudioEngine.shared.connect(node: synth.sourceNode)
        synthesizer = synth
        currentSwara = swara
    }

    func stopCurrentSwara() {
        if let synth = synthesizer {
            AudioEngine.shared.disconnect(node: synth.sourceNode)
            synth.stop()
        }
        synthesizer = nil
        currentSwara = nil
    }
}
