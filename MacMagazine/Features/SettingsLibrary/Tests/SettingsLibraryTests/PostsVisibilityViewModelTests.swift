import Foundation
@testable import SettingsLibrary
import StorageLibrary
import Testing

@Suite("PostsVisibilityViewModel Tests")
@MainActor
struct PostsVisibilityViewModelTests {

    // MARK: - Clean All Tests

    @Test("Clean all should delete every registered model except SettingsDB")
    func cleanAllDeletesRegisteredModelsExceptSettings() {
        // Given
        let storage = Database(models: [SettingsDB.self, CustomizationDB.self], inMemory: true)
        storage.context.insert(SettingsDB(mode: .dark))
        storage.context.insert(CustomizationDB(tabs: [.news, .settings]))
        try? storage.context.save()

        let viewModel = PostsVisibilityViewModel()
        viewModel.set(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        // When
        viewModel.flush(cache: .cleanAll)

        // Then
        #expect(storage.fetch(SettingsDB.self).count == 1, "SettingsDB should be preserved")
        #expect(storage.fetch(CustomizationDB.self).isEmpty, "CustomizationDB should be deleted")
    }

    @Test("Clean all should delete every object of a model, not just the first")
    func cleanAllDeletesAllObjectsIndividually() {
        // Given
        let storage = Database(models: [CustomizationDB.self], inMemory: true)
        storage.context.insert(CustomizationDB(tabs: [.news]))
        storage.context.insert(CustomizationDB(tabs: [.live]))
        storage.context.insert(CustomizationDB(tabs: [.settings]))
        try? storage.context.save()
        #expect(storage.fetch(CustomizationDB.self).count == 3)

        let viewModel = PostsVisibilityViewModel()
        viewModel.set(storage: storage, models: [CustomizationDB.self])

        // When
        viewModel.flush(cache: .cleanAll)

        // Then
        #expect(storage.fetch(CustomizationDB.self).isEmpty, "All objects should be deleted, not just the first")
    }

    @Test("Clean all should handle an empty database without error")
    func cleanAllHandlesEmptyDatabase() {
        // Given
        let storage = Database(models: [CustomizationDB.self], inMemory: true)
        let viewModel = PostsVisibilityViewModel()
        viewModel.set(storage: storage, models: [CustomizationDB.self])

        // When
        viewModel.flush(cache: .cleanAll)

        // Then
        #expect(storage.fetch(CustomizationDB.self).isEmpty)
    }
}
