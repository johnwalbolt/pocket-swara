import AVFoundation

class HarmoniumSynthesizer: SynthesizerProtocol {
    private(set) var isPlaying = false
    private var amplitude: Float = 0.5

    private let maxVoices = 10
    private var voices: [Voice] = []
    private var bellowsPhase: Float = 0
    private let bellowsRate: Float = 1.2   // Hz, slow LFO

    private let sampleRate: Float = 44100

    // Reed organ harmonic profile (odd harmonics slightly louder)
    private let harmonicAmplitudes: [Float] = [1.0, 0.6, 0.8, 0.4, 0.5, 0.25, 0.3, 0.15]

    struct Voice {
        var frequency: Float
        var phases: [Float]
        var envelope: Float
        var state: VoiceState
        let attackRate: Float
        let releaseRate: Float

        enum VoiceState {
            case attack, sustain, release, free
        }

        mutating func advanceEnvelope() {
            switch state {
            case .attack:
                envelope += attackRate
                if envelope >= 1.0 {
                    envelope = 1.0
                    state = .sustain
                }
            case .sustain:
                break
            case .release:
                envelope -= releaseRate
                if envelope <= 0 {
                    envelope = 0
                    state = .free
                }
            case .free:
                break
            }
        }
    }

    lazy var sourceNode: AVAudioSourceNode = {
        AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self = self else { return noErr }

            let bufferList = UnsafeMutableAudioBufferListPointer(audioBufferList)
            guard let buffer = bufferList.first?.mData?.assumingMemoryBound(to: Float.self) else {
                return noErr
            }

            let twoPi = Float.pi * 2

            for frame in 0..<Int(frameCount) {
                // Bellows LFO
                let bellowsMod = 1.0 + 0.03 * sin(self.bellowsPhase * twoPi)
                self.bellowsPhase += self.bellowsRate / self.sampleRate
                if self.bellowsPhase >= 1.0 { self.bellowsPhase -= 1.0 }

                var totalSample: Float = 0

                for v in 0..<self.voices.count {
                    guard self.voices[v].state != .free else { continue }

                    self.voices[v].advanceEnvelope()

                    var voiceSample: Float = 0
                    for (h, amp) in self.harmonicAmplitudes.enumerated() {
                        voiceSample += sin(self.voices[v].phases[h] * twoPi) * amp
                    }

                    let maxAmp = self.harmonicAmplitudes.reduce(0, +)
                    voiceSample = voiceSample / maxAmp * self.voices[v].envelope

                    totalSample += voiceSample

                    // Advance harmonic phases
                    for h in 0..<self.voices[v].phases.count {
                        let harmonicNum = Float(h + 1)
                        // Slight detuning for warmth
                        let detune: Float = 1.0 + Float.random(in: -0.0003...0.0003)
                        self.voices[v].phases[h] += self.voices[v].frequency * harmonicNum * detune / self.sampleRate
                        if self.voices[v].phases[h] >= 1.0 { self.voices[v].phases[h] -= 1.0 }
                    }
                }

                let activeCount = max(1.0, Float(self.voices.filter { $0.state != .free }.count))
                totalSample = totalSample / activeCount * self.amplitude * Float(bellowsMod)

                buffer[frame] = totalSample
            }

            return noErr
        }
    }()

    init() {}

    func setFrequency(_ frequency: Float) {}

    func setAmplitude(_ amplitude: Float) {
        self.amplitude = amplitude
    }

    func start() {
        isPlaying = true
    }

    func stop() {
        isPlaying = false
        for i in 0..<voices.count {
            voices[i].state = .release
        }
    }

    func noteOn(frequency: Float) {
        // Check if this frequency is already playing
        if let index = voices.firstIndex(where: { abs($0.frequency - frequency) < 0.1 && $0.state != .free }) {
            voices[index].state = .attack
            return
        }

        // Find a free voice
        if let freeIndex = voices.firstIndex(where: { $0.state == .free }) {
            voices[freeIndex] = makeVoice(frequency: frequency)
            return
        }

        // Add new voice if under limit
        if voices.count < maxVoices {
            voices.append(makeVoice(frequency: frequency))
            return
        }

        // Steal oldest releasing voice
        if let releasingIndex = voices.firstIndex(where: { $0.state == .release }) {
            voices[releasingIndex] = makeVoice(frequency: frequency)
        }
    }

    func noteOff(frequency: Float) {
        if let index = voices.firstIndex(where: { abs($0.frequency - frequency) < 0.1 && $0.state != .free && $0.state != .release }) {
            voices[index].state = .release
        }
    }

    private func makeVoice(frequency: Float) -> Voice {
        Voice(
            frequency: frequency,
            phases: [Float](repeating: 0, count: harmonicAmplitudes.count),
            envelope: 0,
            state: .attack,
            attackRate: 1.0 / (0.02 * sampleRate),    // 20ms attack
            releaseRate: 1.0 / (0.08 * sampleRate)     // 80ms release
        )
    }
}
