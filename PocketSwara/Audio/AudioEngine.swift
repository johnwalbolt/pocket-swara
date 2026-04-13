import AVFoundation

class AudioEngine {
    static let shared = AudioEngine()

    private let engine = AVAudioEngine()
    private let mixer = AVAudioMixerNode()
    private let format: AVAudioFormat
    private var connectedNodes: Set<ObjectIdentifier> = []

    private init() {
        format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!

        engine.attach(mixer)
        engine.connect(mixer, to: engine.mainMixerNode, format: format)

        do {
            try engine.start()
        } catch {
            print("AudioEngine failed to start: \(error)")
        }
    }

    var sampleRate: Double { 44100 }

    func connect(node: AVAudioSourceNode) {
        let id = ObjectIdentifier(node)
        guard !connectedNodes.contains(id) else { return }

        engine.attach(node)
        engine.connect(node, to: mixer, format: format)
        connectedNodes.insert(id)

        if !engine.isRunning {
            do {
                try engine.start()
            } catch {
                print("AudioEngine failed to restart: \(error)")
            }
        }
    }

    func disconnect(node: AVAudioSourceNode) {
        let id = ObjectIdentifier(node)
        guard connectedNodes.contains(id) else { return }

        engine.disconnectNodeInput(node)
        engine.detach(node)
        connectedNodes.remove(id)
    }

    func pause() {
        engine.pause()
    }

    func resume() {
        do {
            try engine.start()
        } catch {
            print("AudioEngine failed to resume: \(error)")
        }
    }

    var inputNode: AVAudioInputNode {
        engine.inputNode
    }

    func installInputTap(bufferSize: AVAudioFrameCount, format: AVAudioFormat?, block: @escaping (AVAudioPCMBuffer, AVAudioTime) -> Void) {
        engine.inputNode.installTap(onBus: 0, bufferSize: bufferSize, format: format, block: block)
    }

    func removeInputTap() {
        engine.inputNode.removeTap(onBus: 0)
    }
}
