import Foundation

class KarplusStrongBuffer {
    private var buffer: [Float]
    private var readIndex: Int = 0
    private let bufferLength: Int
    var decayFactor: Float = 0.996
    var jawariGain: Float = 3.0

    init(frequency: Float, sampleRate: Float = 44100) {
        bufferLength = max(2, Int(sampleRate / frequency))
        buffer = [Float](repeating: 0, count: bufferLength)
    }

    func excite() {
        // Fill buffer with low-pass filtered noise for pluck excitation
        for i in 0..<bufferLength {
            buffer[i] = Float.random(in: -0.5...0.5)
        }
        // Simple low-pass: average adjacent samples
        for i in 0..<bufferLength {
            let next = (i + 1) % bufferLength
            buffer[i] = (buffer[i] + buffer[next]) * 0.5
        }
        readIndex = 0
    }

    func nextSample() -> Float {
        let currentIndex = readIndex
        let nextIndex = (readIndex + 1) % bufferLength

        // Karplus-Strong: average of current and next, with decay
        let averaged = (buffer[currentIndex] + buffer[nextIndex]) * 0.5 * decayFactor

        // Jawari (buzz): soft-clipping nonlinearity
        let buzzed = tanh(jawariGain * averaged) / tanh(jawariGain)

        buffer[currentIndex] = buzzed

        readIndex = nextIndex
        return buzzed
    }

    func updateFrequency(_ frequency: Float, sampleRate: Float = 44100) {
        let newLength = max(2, Int(sampleRate / frequency))
        if newLength != bufferLength {
            // Re-create buffer at new frequency
            buffer = [Float](repeating: 0, count: newLength)
        }
    }
}
