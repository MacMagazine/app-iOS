import Foundation
import StorageLibrary
import SwiftData

extension Storage {
    @MainActor
    func save(event: MMLive) {
        if let encoded = try? JSONEncoder().encode(event) {
            self.save(object: encoded, key: "mmLive")
        }
    }

    @MainActor
    func get() -> MMLive? {
        guard let data = self.get(key: "mmLive") as? Data,
              let event = try? JSONDecoder().decode(MMLive.self, from: data) else { return nil }
        return event
    }
}
