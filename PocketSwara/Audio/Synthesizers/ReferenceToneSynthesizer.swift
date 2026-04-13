import AVFoundation

class ReferenceToneSynthesizer: SynthesizerProtocol {
    private(set) var isPlaying = false
    private var frequency: Float
    private var amplitude: Float = 0.5
    private var phase: Float = 0
    private var phase2: Float = 0
    private var phase3: Float = 0
    private var envelopeLevel: Float = 0
    private let attackTime: Float = 0.05    // 50ms
    private let releaseTime: Float = 0.05
    private var releasing = false

    private let sampleRate: Float = 44100

    lazy var sourceNode: AVAudioSourceNode = {
        AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self = self else { return noErr }

            let bufferList = UnsafeMutableAudioBufferListPointer(audioBufferList)
            guard let buffer = bufferList.first?.mData?.assumingMemoryBound(to: Float.self) else {
                return noErr
            }

            let twoPi = Float.pi * 2
            let phaseIncrement = self.frequency / self.sampleRate
            let phaseIncrement2 = self.frequency * 2 / self.sampleRate
            let phaseIncrement3 = self.frequency * 3 / self.sampleRate

            for frame in 0..<Int(frameCount) {
                // Envelope
                if self.releasing {
                    self.envelopeLevel = max(0, self.envelopeLevel - 1.0 / (self.releaseTime * self.sampleRate))
                } else if self.isPlaying {
                    self.envelopeLevel = min(1, self.envelopeLevel + 1.0 / (self.attackTime * self.sampleRate))
                }

                // Fundamental + 2nd harmonic (-12dB) + 3rd harmonic (-18dB)
                let fundamental = sin(self.phase * twoPi)
                let harmonic2 = sin(self.phase2 * twoPi) * 0.25   // -12dB
                let harmonic3 = sin(self.phase3 * twoPi) * 0.125  // -18dB

                let sample = (fundamental + harmonic2 + harmonic3) * self.amplitude * self.envelopeLevel

                buffer[frame] = sample

                self.phase += phaseIncrement
                self.phase2 += phaseIncrement2
                self.phase3 += phaseIncrement3

                if self.phase >= 1.0 { self.phase -= 1.0 }
                if self.phase2 >= 1.0 { self.phase2 -= 1.0 }
                if self.phase3 >= 1.0 { self.phase3 -= 1.0 }
            }

            return noErr
        }
    }()

    init(frequency: Float) {
        self.frequency = frequency
    }

    func setFrequency(_ frequency: Float) {
        self.frequency = frequency
    }

    func setAmplitude(_ amplitude: Float) {
        self.amplitude = amplitude
    }

    func start() {
        releasing = false
        isPlaying = true
    }

    func stop() {
        releasing = true
        isPlaying = false
    }
}
