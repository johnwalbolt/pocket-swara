import Foundation

@Observable
class RagaSelectorViewModel {
    var searchText = ""

    var filteredRagas: [Raga] {
        if searchText.isEmpty {
            return RagaDatabase.allRagas
        }
        let query = searchText.lowercased()
        return RagaDatabase.allRagas.filter { raga in
            raga.name.lowercased().contains(query) ||
            raga.alternateNames.contains { $0.lowercased().contains(query) } ||
            raga.thaat.lowercased().contains(query)
        }
    }
}
