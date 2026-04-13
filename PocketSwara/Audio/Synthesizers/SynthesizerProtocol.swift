import AVFoundation

protocol SynthesizerProtocol: AnyObject {
    var sourceNode: AVAudioSourceNode { get }
    var isPlaying: Bool { get }
    func setFrequency(_ frequency: Float)
    func setAmplitude(_ amplitude: Float)
    func start()
    func stop()
}
