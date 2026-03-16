import Foundation
@testable import SettingsLibrary
import StorageLibrary
import Testing

@Suite("Database Extensions Tests")
@MainActor
struct DatabaseExtensionsTests {

    // MARK: - Settings Singleton and Duplicate Cleanup Tests

    @Test("Should return nil when no settings exist")
    func settingsNilWhenEmpty() {
        // Given
        let database = Database(models: [SettingsDB.self], inMemory: true)

        // When
        let settings = database.settings

        // Then
        #expect(settings == nil, "Should return nil when no settings exist")
    }

    @Test("Should return first settings when only one exists")
    func settingsReturnFirstWhenSingle() {
        // Given
        let database = Database(models: [SettingsDB.self], inMemory: true)
        let settingsDB = SettingsDB(mode: .dark)
        database.context.insert(settingsDB)
        try? database.context.save()

        // When
        let settings = database.settings

        // Then
        #expect(settings != nil, "Should return settings")
        #expect(settings?.mode == .dark, "Should return correct settings")
    }

    @Test("Should delete duplicates and return first when multiple settings exist")
    func settingsDeleteDuplicates() {
        // Given
        let database = Database(models: [SettingsDB.self], inMemory: true)

        // Insert 3 settings (duplicates)
        database.context.insert(SettingsDB(mode: .light))
        database.context.insert(SettingsDB(mode: .dark))
        database.context.insert(SettingsDB(mode: .system))
        try? database.context.save()

        // Verify 3 exist
        #expect(database.fetch(SettingsDB.self).count == 3)

        // When
        let settings = database.settings

        // Then
        #expect(settings != nil, "Should return a settings object")
        #expect(database.fetch(SettingsDB.self).count == 1, "Should delete duplicates, leaving only one")
    }

    // MARK: - Customization Singleton and Duplicate Cleanup Tests

    @Test("Should return nil when no customization exists")
    func customizationNilWhenEmpty() {
        // Given
        let database = Database(models: [CustomizationDB.self], inMemory: true)

        // When
        let customization = database.customization

        // Then
        #expect(customization == nil, "Should return nil when no customization exists")
    }

    @Test("Should return first customization when only one exists")
    func customizationReturnFirstWhenSingle() {
        // Given
        let database = Database(models: [CustomizationDB.self], inMemory: true)
        let customDB = CustomizationDB(tabs: [.news, .settings])
        database.context.insert(customDB)
        try? database.context.save()

        // When
        let customization = database.customization

        // Then
        #expect(customization != nil, "Should return customization")
        #expect(customization?.tabs.count == 2, "Should return correct customization")
    }

    @Test("Should delete duplicates and return first when multiple customizations exist")
    func customizationDeleteDuplicates() {
        // Given
        let database = Database(models: [CustomizationDB.self], inMemory: true)

        // Insert 3 customizations (duplicates)
        database.context.insert(CustomizationDB(tabs: [.news]))
        database.context.insert(CustomizationDB(tabs: [.live]))
        database.context.insert(CustomizationDB(tabs: [.settings]))
        try? database.context.save()

        // Verify 3 exist
        #expect(database.fetch(CustomizationDB.self).count == 3)

        // When
        let customization = database.customization

        // Then
        #expect(customization != nil, "Should return a customization object")
        #expect(database.fetch(CustomizationDB.self).count == 1, "Should delete duplicates, leaving only one")
    }

    // MARK: - Update isPatrao Date Calculation Tests

    @Test("Should add 30 days when isPatrao is true")
    func updateIsPatraoTrueAdds30Days() {
        // Given
        let database = Database(models: [SettingsDB.self], inMemory: true)
        let now = Date()

        // When
        database.update(isPatrao: true)

        // Then
        let settings = database.settings
        #expect(settings != nil)

        guard let expirationDate = settings?.subscription.expirationDate else {
            Issue.record("Not expected error")
            return
        }
        let daysDifference = Calendar.current.dateComponents([.day], from: now, to: expirationDate).day ?? 0

        #expect(daysDifference >= 29 && daysDifference <= 31,
                "Should add approximately 30 days when isPatrao is true (got \(daysDifference) days)")
    }

    @Test("Should subtract 1 day when isPatrao is false")
    func updateIsPatraoFalseSubtracts1Day() {
        // Given
        let database = Database(models: [SettingsDB.self], inMemory: true)
        let now = Date()

        // When
        database.update(isPatrao: false)

        // Then
        let settings = database.settings
        #expect(settings != nil)

        guard let expirationDate = settings?.subscription.expirationDate else {
            Issue.record("Not expected error")
            return
        }
        let daysDifference = Calendar.current.dateComponents([.day], from: expirationDate, to: now).day ?? 0

        #expect(daysDifference >= 0 && daysDifference <= 2,
                "Should subtract approximately 1 day when isPatrao is false (got \(daysDifference) days in past)")
    }

    @Test("Should update existing settings when isPatrao changes")
    func updateIsPatraoUpdatesExisting() {
        // Given
        let database = Database(models: [SettingsDB.self], inMemory: true)
        database.update(isPatrao: false)

        let settingsBefore = database.settings
        let idBefore = settingsBefore?.id

        // When
        database.update(isPatrao: true)

        // Then
        let settingsAfter = database.settings
        #expect(settingsAfter?.id == idBefore, "Should update same object, not create new one")
        #expect(settingsAfter?.subscription.isPatrao == true, "Should update isPatrao value")
    }

    // MARK: - Upsert Pattern Tests (Update Existing vs Insert New)

    @Test("Should insert new SettingsDB when none exists")
    func updateModeInsertsWhenEmpty() {
        // Given
        let database = Database(models: [SettingsDB.self], inMemory: true)
        #expect(database.settings == nil, "Should start empty")

        // When
        database.update(mode: .dark)

        // Then
        let settings = database.settings
        #expect(settings != nil, "Should create new settings")
        #expect(settings?.mode == .dark, "Should have correct mode")
        #expect(database.fetch(SettingsDB.self).count == 1, "Should have exactly one settings")
    }

    @Test("Should update existing SettingsDB when one exists")
    func updateModeUpdatesExisting() {
        // Given
        let database = Database(models: [SettingsDB.self], inMemory: true)
        database.update(mode: .light)

        let settingsBefore = database.settings
        let idBefore = settingsBefore?.id

        // When
        database.update(mode: .dark)

        // Then
        let settingsAfter = database.settings
        #expect(settingsAfter?.id == idBefore, "Should update same object")
        #expect(settingsAfter?.mode == .dark, "Should update mode value")
        #expect(database.fetch(SettingsDB.self).count == 1, "Should still have only one settings")
    }

    @Test("Should insert new CustomizationDB when none exists")
    func updateTabsInsertsWhenEmpty() {
        // Given
        let database = Database(models: [CustomizationDB.self], inMemory: true)
        #expect(database.customization == nil, "Should start empty")

        // When
        database.update(tabs: [.news, .settings])

        // Then
        let customization = database.customization
        #expect(customization != nil, "Should create new customization")
        #expect(customization?.tabs == [.news, .settings], "Should have correct tabs")
        #expect(database.fetch(CustomizationDB.self).count == 1, "Should have exactly one customization")
    }

    @Test("Should update existing CustomizationDB when one exists")
    func updateTabsUpdatesExisting() {
        // Given
        let database = Database(models: [CustomizationDB.self], inMemory: true)
        database.update(tabs: [.news])

        let customBefore = database.customization
        let idBefore = customBefore?.id

        // When
        database.update(tabs: [.news, .live, .settings])

        // Then
        let customAfter = database.customization
        #expect(customAfter?.id == idBefore, "Should update same object")
        #expect(customAfter?.tabs == [.news, .live, .settings], "Should update tabs array")
        #expect(database.fetch(CustomizationDB.self).count == 1, "Should still have only one customization")
    }

    // MARK: - Individual Update Method Tests

    @Test("Should update app icon correctly")
    func updateAppIcon() {
        // Given
        let database = Database(models: [SettingsDB.self], inMemory: true)

        // When
        database.update(appIcon: .alternative)

        // Then
        let settings = database.settings
        #expect(settings?.icon == .alternative, "Should update icon")
    }

    @Test("Should update notification preference correctly")
    func updateNotification() {
        // Given
        let database = Database(models: [SettingsDB.self], inMemory: true)

        // When
        database.update(notification: "test_notification")

        // Then
        let settings = database.settings
        #expect(settings?.notification == "test_notification", "Should update notification")
    }

    @Test("Should update expiration date correctly")
    func updateExpirationDate() {
        // Given
        let database = Database(models: [SettingsDB.self], inMemory: true)
        let futureDate = Date().addingTimeInterval(86400 * 365) // 1 year

        // When
        database.update(expirationDate: futureDate)

        // Then
        let settings = database.settings
        #expect(settings?.subscription.expirationDate.timeIntervalSince1970 ==
                futureDate.timeIntervalSince1970,
                "Should update expiration date")
        #expect(settings?.subscription.isPatrao == false, "Should set isPatrao to false")
    }

    @Test("Should update social array correctly")
    func updateSocial() {
        // Given
        let database = Database(models: [CustomizationDB.self], inMemory: true)

        // When
        database.update(social: [.podcast, .videos])

        // Then
        let customization = database.customization
        #expect(customization?.social == [.podcast, .videos], "Should update social array")
    }

    @Test("Should update news array correctly")
    func updateNews() {
        // Given
        let database = Database(models: [CustomizationDB.self], inMemory: true)

        // When
        database.update(news: [.highlights, .reviews])

        // Then
        let customization = database.customization
        #expect(customization?.news == [.highlights, .reviews], "Should update news array")
    }

    // MARK: - Edge Cases

    @Test("Should handle empty arrays in customization")
    func updateWithEmptyArrays() {
        // Given
        let database = Database(models: [CustomizationDB.self], inMemory: true)

        // When
        database.update(tabs: [])
        database.update(social: [])
        database.update(news: [])

        // Then
        let customization = database.customization
        #expect(customization?.tabs.isEmpty == true, "Should handle empty tabs")
        #expect(customization?.social.isEmpty == true, "Should handle empty social")
        #expect(customization?.news.isEmpty == true, "Should handle empty news")
    }

    @Test("Should handle multiple rapid updates correctly")
    func multipleRapidUpdates() {
        // Given
        let database = Database(models: [SettingsDB.self], inMemory: true)

        // When - Rapid fire updates
        database.update(mode: .light)
        database.update(appIcon: .alternative)

        // Then
        let settings = database.settings
        #expect(settings?.mode == .light, "Should have latest mode")
        #expect(settings?.icon == .alternative, "Should have latest icon")
        #expect(database.fetch(SettingsDB.self).count == 1, "Should still have only one settings object")
    }

    @Test("Should preserve other fields when updating one field")
    func preserveOtherFieldsOnUpdate() {
        // Given
        let database = Database(models: [SettingsDB.self], inMemory: true)
        database.update(mode: .dark)

        // When
        database.update(appIcon: .normal)

        // Then
        let settings = database.settings
        #expect(settings?.mode == .dark, "Should preserve mode")
        #expect(settings?.icon == .normal, "Should update icon")
    }
}
