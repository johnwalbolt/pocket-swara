import AVFoundation

class ShrutiBoxSynthesizer: SynthesizerProtocol {
    private(set) var isPlaying = false
    private var frequency: Float
    private var amplitude: Float = 0.5
    private var envelopeLevel: Float = 0
    private let fadeInTime: Float = 0.15   // 150ms
    private let fadeOutTime: Float = 0.15

    private var phases: [Float]   // One per harmonic
    private let harmonicAmplitudes: [Float] = [1.0, 0.7, 0.5, 0.35, 0.25, 0.15]
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

            for frame in 0..<Int(frameCount) {
                // Envelope
                if self.releasing {
                    self.envelopeLevel = max(0, self.envelopeLevel - 1.0 / (self.fadeOutTime * self.sampleRate))
                } else if self.isPlaying {
                    self.envelopeLevel = min(1, self.envelopeLevel + 1.0 / (self.fadeInTime * self.sampleRate))
                }

                // Additive synthesis: organ-like harmonic series
                var sample: Float = 0
                for (i, amp) in self.harmonicAmplitudes.enumerated() {
                    sample += sin(self.phases[i] * twoPi) * amp
                }

                // Normalize
                let maxAmp = self.harmonicAmplitudes.reduce(0, +)
                sample = sample / maxAmp * self.amplitude * self.envelopeLevel

                buffer[frame] = sample

                // Advance phases
                for i in 0..<self.phases.count {
                    let harmonicNumber = Float(i + 1)
                    self.phases[i] += self.frequency * harmonicNumber / self.sampleRate
                    if self.phases[i] >= 1.0 { self.phases[i] -= 1.0 }
                }
            }

            return noErr
        }
    }()

    init(frequency: Float) {
        self.frequency = frequency
        self.phases = [Float](repeating: 0, count: harmonicAmplitudes.count)
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
