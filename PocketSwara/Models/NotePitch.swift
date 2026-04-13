import Foundation

struct NotePitch: Identifiable, Hashable {
    let noteName: String
    let octave: Int
    let midiNote: Int

    var id: Int { midiNote }

    var frequency: Float {
        440.0 * powf(2.0, Float(midiNote - 69) / 12.0)
    }

    var displayName: String {
        "\(noteName)\(octave)"
    }

    static let defaultSa = NotePitch(noteName: "C", octave: 4, midiNote: 60)

    static let allNotes: [NotePitch] = {
        let noteNames = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        var notes: [NotePitch] = []
        // C2 (MIDI 36) to C6 (MIDI 84)
        for midi in 36...84 {
            let octave = (midi / 12) - 1
            let noteIndex = midi % 12
            notes.append(NotePitch(
                noteName: noteNames[noteIndex],
                octave: octave,
                midiNote: midi
            ))
        }
        return notes
    }()
}
