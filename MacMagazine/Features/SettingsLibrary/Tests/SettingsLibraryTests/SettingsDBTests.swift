import Foundation
@testable import SettingsLibrary
import StorageLibrary
import Testing

@Suite("SettingsDB Deduplication Tests")
@MainActor
struct SettingsDBTests {

    @Test("Deduplicate keeps the most recently modified record when there is no subscription conflict")
    func deduplicateKeepsMostRecent() {
        let database = Database(models: [SettingsDB.self], inMemory: true)
        let older = SettingsDB(icon: .normal, modifiedAt: Date().addingTimeInterval(-60))
        let newer = SettingsDB(icon: .alternative, modifiedAt: Date())
        database.context.insert(older)
        database.context.insert(newer)
        try? database.context.save()

        SettingsDB.deduplicate(using: database.context)

        let remaining = database.fetch(SettingsDB.self)
        #expect(remaining.count == 1)
        #expect(remaining.first?.icon == .alternative)
    }

    @Test("Deduplicate keeps a valid subscription from a stale device instead of the most recently modified row")
    func deduplicatePreservesValidSubscriptionFromStaleRow() {
        let database = Database(models: [SettingsDB.self], inMemory: true)
        let validSubscription = Subscription(isPatrao: false, expirationDate: Date().addingTimeInterval(86_400 * 30))
        let staleDeviceWithValidSubscription = SettingsDB(
            subscription: validSubscription,
            modifiedAt: Date().addingTimeInterval(-3_600)
        )
        let freshDeviceNeverRestored = SettingsDB(
            subscription: Subscription(isPatrao: false, expirationDate: Date().addingTimeInterval(-86_400)),
            modifiedAt: Date()
        )
        database.context.insert(staleDeviceWithValidSubscription)
        database.context.insert(freshDeviceNeverRestored)
        try? database.context.save()

        SettingsDB.deduplicate(using: database.context)

        let remaining = database.fetch(SettingsDB.self)
        #expect(remaining.count == 1)
        #expect(remaining.first?.subscription.isValidSubscription == true,
                "A valid subscription on one device must not be lost to a stale row on another")
    }

    @Test("Deduplicate preserves isPatrao true even when it only exists on the older row")
    func deduplicatePreservesPatraoFromOlderRow() {
        let database = Database(models: [SettingsDB.self], inMemory: true)
        let olderPatrao = SettingsDB(
            subscription: Subscription(isPatrao: true, expirationDate: Date().addingTimeInterval(86_400)),
            modifiedAt: Date().addingTimeInterval(-3_600)
        )
        let newerNonPatrao = SettingsDB(
            subscription: Subscription(isPatrao: false, expirationDate: Date().addingTimeInterval(-86_400)),
            modifiedAt: Date()
        )
        database.context.insert(olderPatrao)
        database.context.insert(newerNonPatrao)
        try? database.context.save()

        SettingsDB.deduplicate(using: database.context)

        let remaining = database.fetch(SettingsDB.self)
        #expect(remaining.count == 1)
        #expect(remaining.first?.subscription.isPatrao == true)
    }

    @Test("Deduplicate does nothing when there is a single record")
    func deduplicateNoOpWithSingleRecord() {
        let database = Database(models: [SettingsDB.self], inMemory: true)
        database.context.insert(SettingsDB(icon: .normal))
        try? database.context.save()

        SettingsDB.deduplicate(using: database.context)

        #expect(database.fetch(SettingsDB.self).count == 1)
    }
}
