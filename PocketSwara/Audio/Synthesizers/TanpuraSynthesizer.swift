import AVFoundation

class TanpuraSynthesizer: SynthesizerProtocol {
    private(set) var isPlaying = false
    private var amplitude: Float = 0.6

    // 4 strings: string pattern for Sa-Pa is [Pa, Sa, Sa, Sa(low)]
    // For Sa-Ma: [Ma, Sa, Sa, Sa(low)]
    private var strings: [KarplusStrongBuffer] = []
    private var stringFrequencies: [Float] = []
    private var currentStringIndex: Int = 0
    private var samplesSinceLastPluck: Int = 0
    private var pluckIntervalSamples: Int = 26460 // ~0.6s at 44100

    private let sampleRate: Float = 44100

    lazy var sourceNode: AVAudioSourceNode = {
        AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self = self, self.isPlaying else {
                // Fill with silence
                let bufferList = UnsafeMutableAudioBufferListPointer(audioBufferList)
                if let buffer = bufferList.first?.mData?.assumingMemoryBound(to: Float.self) {
                    for frame in 0..<Int(frameCount) {
                        buffer[frame] = 0
                    }
                }
                return noErr
            }

            let bufferList = UnsafeMutableAudioBufferListPointer(audioBufferList)
            guard let buffer = bufferList.first?.mData?.assumingMemoryBound(to: Float.self) else {
                return noErr
            }

            for frame in 0..<Int(frameCount) {
                // Check if it's time to pluck the next string
                self.samplesSinceLastPluck += 1
                if self.samplesSinceLastPluck >= self.pluckIntervalSamples {
                    self.samplesSinceLastPluck = 0
                    if !self.strings.isEmpty {
                        self.strings[self.currentStringIndex].excite()
                        self.currentStringIndex = (self.currentStringIndex + 1) % self.strings.count
                    }
                }

                // Sum all strings
                var sample: Float = 0
                for string in self.strings {
                    sample += string.nextSample()
                }

                // Normalize and apply amplitude
                sample = sample / max(1.0, Float(self.strings.count)) * self.amplitude

                buffer[frame] = sample
            }

            return noErr
        }
    }()

    init(baseSaFrequency: Float, droneMode: DroneMode, pluckRate: Double) {
        self.pluckIntervalSamples = Int(pluckRate * Double(sampleRate))

        let saFreq = baseSaFrequency
        let secondFreq = droneMode.secondSwara.frequency(baseSaFrequency: baseSaFrequency)
        let saLowFreq = baseSaFrequency / 2.0

        // 4 strings
        stringFrequencies = [secondFreq, saFreq, saFreq, saLowFreq]
        strings = stringFrequencies.map { freq in
            let buf = KarplusStrongBuffer(frequency: freq, sampleRate: sampleRate)
            buf.jawariGain = 2.5
            buf.decayFactor = 0.998
            return buf
        }
    }

    func setFrequency(_ frequency: Float) {
        // Not used directly - use updateFrequencies instead
    }

    func setAmplitude(_ amplitude: Float) {
        self.amplitude = amplitude
    }

    func start() {
        isPlaying = true
        samplesSinceLastPluck = pluckIntervalSamples // Trigger first pluck immediately
        currentStringIndex = 0
    }

    func stop() {
        isPlaying = false
    }

    func updateFrequencies(baseSaFrequency: Float, droneMode: DroneMode) {
        let saFreq = baseSaFrequency
        let secondFreq = droneMode.secondSwara.frequency(baseSaFrequency: baseSaFrequency)
        let saLowFreq = baseSaFrequency / 2.0

        stringFrequencies = [secondFreq, saFreq, saFreq, saLowFreq]
        for (i, freq) in stringFrequencies.enumerated() {
            if i < strings.count {
                strings[i].updateFrequency(freq, sampleRate: sampleRate)
            }
        }
    }
}
