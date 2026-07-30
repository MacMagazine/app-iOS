import Foundation
@testable import SafeguardLibrary
import StorageLibrary
import SwiftData
import Testing

@Suite("Safeguard Coordinator Tests")
@MainActor
struct SafeguardCoordinatorTests {

    private static let versionKey = "lastSafeguardedVersion"

    private func makeDefaults() throws -> UserDefaults {
        try #require(UserDefaults(suiteName: "safeguard.tests.\(UUID().uuidString)"))
    }

    private func makeCoordinator(
        models: [any PersistentModel.Type] = [RecordingModel.self],
        mainContext: ModelContext? = nil,
        statusSource: SafeguardStatusSource,
        clock: SafeguardClock,
        defaults: UserDefaults,
        version: String = "5.1.0 (100)",
        fetch: @escaping @MainActor () async -> Void = {},
        deduplicate: @escaping @MainActor () -> Void = {}
    ) -> SafeguardCoordinator? {
        SafeguardCoordinator.createIfNeeded(
            models: models,
            mainContext: mainContext,
            statusSource: statusSource,
            clock: clock,
            defaults: defaults,
            version: version,
            fetch: fetch,
            deduplicate: deduplicate
        )
    }

    // MARK: - Version Gate Tests

    @Test("createIfNeeded fires when no version was ever safeguarded")
    func createIfNeededFiresOnFirstRun() throws {
        let clock = FakeClock()
        let coordinator = makeCoordinator(statusSource: FakeStatusSource(isSyncEnabled: false, clock: clock),
                                          clock: clock,
                                          defaults: try makeDefaults())

        #expect(coordinator != nil)
        #expect(coordinator?.phase == .snapshotting)
    }

    @Test("createIfNeeded returns nil when the stored version is unchanged")
    func createIfNeededSkipsUnchangedVersion() throws {
        let clock = FakeClock()
        let defaults = try makeDefaults()
        defaults.set("5.1.0 (100)", forKey: Self.versionKey)

        let coordinator = makeCoordinator(statusSource: FakeStatusSource(isSyncEnabled: false, clock: clock),
                                          clock: clock,
                                          defaults: defaults,
                                          version: "5.1.0 (100)")

        #expect(coordinator == nil)
    }

    @Test("createIfNeeded fires when the marketing version changed")
    func createIfNeededFiresOnVersionChange() throws {
        let clock = FakeClock()
        let defaults = try makeDefaults()
        defaults.set("5.0.1 (100)", forKey: Self.versionKey)

        let coordinator = makeCoordinator(statusSource: FakeStatusSource(isSyncEnabled: false, clock: clock),
                                          clock: clock,
                                          defaults: defaults,
                                          version: "5.1.0 (100)")

        #expect(coordinator != nil)
    }

    @Test("createIfNeeded fires when only the build number changed")
    func createIfNeededFiresOnBuildOnlyChange() throws {
        let clock = FakeClock()
        let defaults = try makeDefaults()
        defaults.set("5.1.0 (100)", forKey: Self.versionKey)

        let coordinator = makeCoordinator(statusSource: FakeStatusSource(isSyncEnabled: false, clock: clock),
                                          clock: clock,
                                          defaults: defaults,
                                          version: "5.1.0 (101)")

        #expect(coordinator != nil)
    }

    @Test("resetSafeguard clears the stored version so the flow fires again")
    func resetSafeguardClearsStoredVersion() throws {
        let defaults = try makeDefaults()
        defaults.set("5.1.0 (100)", forKey: Self.versionKey)

        SafeguardCoordinator.resetSafeguard(defaults: defaults)

        #expect(defaults.string(forKey: Self.versionKey) == nil)
    }

    // MARK: - Phase Progression Tests

    @Test("run walks every phase in order and finishes done")
    func runWalksEveryPhaseInOrder() async throws {
        let clock = FakeClock()
        let recorder = PhaseRecorder()

        let safeguard = try #require(makeCoordinator(
            statusSource: FakeStatusSource(isSyncEnabled: false, clock: clock),
            clock: clock,
            defaults: try makeDefaults(),
            fetch: { recorder.record() },
            deduplicate: { recorder.record() }
        ))
        recorder.coordinator = safeguard
        recorder.record()

        await safeguard.run()
        recorder.record()

        #expect(recorder.phases == [.snapshotting, .fetching, .restoring, .done])
    }

    @Test("run writes the version key and releases the snapshot only after a successful restore")
    func runFinalizesOnSuccess() async throws {
        let clock = FakeClock()
        let defaults = try makeDefaults()
        let completion = CompletionFlag()

        let safeguard = try #require(makeCoordinator(statusSource: FakeStatusSource(isSyncEnabled: false, clock: clock),
                                                     clock: clock,
                                                     defaults: defaults))
        safeguard.onComplete = { completion.set() }

        await safeguard.run()

        #expect(safeguard.phase == .done)
        #expect(safeguard.snapshot == nil)
        #expect(defaults.string(forKey: Self.versionKey) == "5.1.0 (100)")
        #expect(completion.isSet)
    }

    @Test("run re-inserts rows the fetch phase removed from the main store")
    func runRestoresRowsLostDuringFetch() async throws {
        let clock = FakeClock()
        let main = Database(models: [RecordingModel.self], inMemory: true)
        main.context.insert(RecordingModel(key: "1"))
        main.context.insert(RecordingModel(key: "2"))
        try main.context.save()

        let safeguard = try #require(makeCoordinator(
            mainContext: main.context,
            statusSource: FakeStatusSource(isSyncEnabled: false, clock: clock),
            clock: clock,
            defaults: try makeDefaults(),
            fetch: {
                main.fetch(RecordingModel.self).forEach { main.context.delete($0) }
                try? main.context.save()
            }
        ))

        await safeguard.run()

        #expect(safeguard.phase == .done)
        #expect(Set(main.fetch(RecordingModel.self).map(\.key)) == ["1", "2"])
    }

    // MARK: - iCloud Wait Tests

    @Test("wait proceeds immediately when the store syncs nothing")
    func waitProceedsWhenSyncDisabled() async throws {
        let clock = FakeClock()
        let statusSource = FakeStatusSource(isSyncEnabled: false, clock: clock)

        let safeguard = try #require(makeCoordinator(statusSource: statusSource, clock: clock, defaults: try makeDefaults()))
        await safeguard.run()

        #expect(statusSource.callCount == 0)
        #expect(clock.elapsed == 0)
    }

    @Test("wait proceeds immediately when the status is already an error")
    func waitProceedsOnCurrentError() async throws {
        let clock = FakeClock()
        let statusSource = FakeStatusSource(currentEvent: .failed, clock: clock)

        let safeguard = try #require(makeCoordinator(statusSource: statusSource, clock: clock, defaults: try makeDefaults()))
        await safeguard.run()

        #expect(statusSource.callCount == 0)
        #expect(clock.elapsed == 0)
    }

    @Test("wait proceeds as soon as an error event arrives")
    func waitProceedsOnErrorEvent() async throws {
        let clock = FakeClock()
        let statusSource = FakeStatusSource(
            currentEvent: .other,
            events: [FakeStatusSource.Event(after: 3, event: .failed)],
            clock: clock
        )

        let safeguard = try #require(makeCoordinator(statusSource: statusSource, clock: clock, defaults: try makeDefaults()))
        await safeguard.run()

        #expect(statusSource.callCount == 1)
        #expect(clock.elapsed == 3)
    }

    @Test("wait ends after the quiesce window once the import is already done")
    func waitEndsAfterQuiesceWindow() async throws {
        let clock = FakeClock()
        let statusSource = FakeStatusSource(currentEvent: .imported, clock: clock)

        let safeguard = try #require(makeCoordinator(statusSource: statusSource, clock: clock, defaults: try makeDefaults()))
        await safeguard.run()

        #expect(statusSource.callCount == 1)
        #expect(clock.elapsed == SafeguardCoordinator.quiesceWindow)
    }

    @Test("a further event restarts the quiesce window")
    func laterEventRestartsQuiesceWindow() async throws {
        let clock = FakeClock()
        let statusSource = FakeStatusSource(
            currentEvent: .other,
            events: [FakeStatusSource.Event(after: 2, event: .imported),
                     FakeStatusSource.Event(after: 1, event: .other)],
            clock: clock
        )

        let safeguard = try #require(makeCoordinator(statusSource: statusSource, clock: clock, defaults: try makeDefaults()))
        await safeguard.run()

        #expect(statusSource.callCount == 3)
        #expect(clock.elapsed == 2 + 1 + SafeguardCoordinator.quiesceWindow)
    }

    @Test("wait gives up at the hard timeout when the import never lands")
    func waitGivesUpAtHardTimeout() async throws {
        let clock = FakeClock()
        let events = (0..<40).map { _ in FakeStatusSource.Event(after: 1, event: .other) }
        let statusSource = FakeStatusSource(currentEvent: .other, events: events, clock: clock)

        let safeguard = try #require(makeCoordinator(statusSource: statusSource, clock: clock, defaults: try makeDefaults()))
        await safeguard.run()

        #expect(clock.elapsed == SafeguardCoordinator.hardTimeout)
        #expect(safeguard.phase == .done)
    }

    // MARK: - Failure Tests

    @Test("a throwing snapshot fails the flow and keeps the snapshot container alive")
    func snapshotFailureRetainsSnapshot() async throws {
        let clock = FakeClock()
        let defaults = try makeDefaults()

        let safeguard = try #require(makeCoordinator(models: [FailingSnapshotModel.self, RecordingModel.self],
                                                     statusSource: FakeStatusSource(isSyncEnabled: false, clock: clock),
                                                     clock: clock,
                                                     defaults: defaults))
        await safeguard.run()

        #expect(safeguard.phase == .failed(SafeguardTestError().localizedDescription))
        #expect(safeguard.snapshot != nil)
        #expect(defaults.string(forKey: Self.versionKey) == nil)
    }

    @Test("a throwing restore fails the flow and keeps the snapshot container alive")
    func restoreFailureRetainsSnapshot() async throws {
        let clock = FakeClock()
        let defaults = try makeDefaults()

        let safeguard = try #require(makeCoordinator(models: [FailingRestoreModel.self],
                                                     statusSource: FakeStatusSource(isSyncEnabled: false, clock: clock),
                                                     clock: clock,
                                                     defaults: defaults))
        await safeguard.run()

        #expect(safeguard.phase == .failed(SafeguardTestError().localizedDescription))
        #expect(safeguard.snapshot != nil)
        #expect(defaults.string(forKey: Self.versionKey) == nil)
    }

    @Test("retry re-runs the restore against the surviving snapshot")
    func retryRestoresAgainstSurvivingSnapshot() async throws {
        let clock = FakeClock()
        let defaults = try makeDefaults()

        let safeguard = try #require(makeCoordinator(models: [FailingSnapshotModel.self, RecordingModel.self],
                                                     statusSource: FakeStatusSource(isSyncEnabled: false, clock: clock),
                                                     clock: clock,
                                                     defaults: defaults))
        await safeguard.run()
        let survivingSnapshot = safeguard.snapshot

        await safeguard.retry()

        #expect(survivingSnapshot != nil)
        #expect(safeguard.phase == .done)
        #expect(defaults.string(forKey: Self.versionKey) == "5.1.0 (100)")
    }

    @Test("retry on a still-failing restore stays failed and still keeps the snapshot")
    func retryKeepsSnapshotWhenRestoreStillFails() async throws {
        let clock = FakeClock()
        let defaults = try makeDefaults()

        let safeguard = try #require(makeCoordinator(models: [FailingRestoreModel.self],
                                                     statusSource: FakeStatusSource(isSyncEnabled: false, clock: clock),
                                                     clock: clock,
                                                     defaults: defaults))
        await safeguard.run()
        await safeguard.retry()

        #expect(safeguard.phase == .failed(SafeguardTestError().localizedDescription))
        #expect(safeguard.snapshot != nil)
        #expect(defaults.string(forKey: Self.versionKey) == nil)
    }

    // MARK: - Restart Tests

    @Test("restart discards the partial snapshot and re-runs the whole flow")
    func restartDiscardsPartialSnapshot() async throws {
        let clock = FakeClock()
        let defaults = try makeDefaults()

        let safeguard = try #require(makeCoordinator(models: [FailingSnapshotModel.self, RecordingModel.self],
                                                     statusSource: FakeStatusSource(isSyncEnabled: false, clock: clock),
                                                     clock: clock,
                                                     defaults: defaults))
        await safeguard.run()
        let partialSnapshot = try #require(safeguard.snapshot)

        await safeguard.restart()

        #expect(safeguard.phase == .failed(SafeguardTestError().localizedDescription))
        #expect(safeguard.snapshot !== partialSnapshot)
    }

    @Test("restart re-snapshots the main store instead of reusing the failed working copy")
    func restartReSnapshotsFromMainStore() async throws {
        let clock = FakeClock()
        let main = Database(models: [RecordingModel.self], inMemory: true)
        main.context.insert(RecordingModel(key: "1"))
        try main.context.save()

        let safeguard = try #require(makeCoordinator(models: [RecordingModel.self],
                                                     mainContext: main.context,
                                                     statusSource: FakeStatusSource(isSyncEnabled: false, clock: clock),
                                                     clock: clock,
                                                     defaults: try makeDefaults()))
        await safeguard.run()

        main.context.insert(RecordingModel(key: "2"))
        try main.context.save()

        await safeguard.restart()

        #expect(safeguard.phase == .done)
        #expect(Set(main.fetch(RecordingModel.self).map(\.key)) == ["1", "2"])
    }

    // MARK: - Fresh Install Detection Tests

    @Test("a store with no safeguardable rows and no earlier run stays silent")
    func freshInstallRunsSilently() throws {
        let clock = FakeClock()
        let main = Database(models: [RecordingModel.self], inMemory: true)

        let safeguard = try #require(makeCoordinator(mainContext: main.context,
                                                     statusSource: FakeStatusSource(isSyncEnabled: false, clock: clock),
                                                     clock: clock,
                                                     defaults: try makeDefaults()))

        #expect(safeguard.isStoreEmpty)
        #expect(!safeguard.shouldPresentUI)
    }

    @Test("a store holding rows presents the view")
    func populatedStorePresentsUI() throws {
        let clock = FakeClock()
        let main = Database(models: [RecordingModel.self], inMemory: true)
        main.context.insert(RecordingModel(key: "1"))
        try main.context.save()

        let safeguard = try #require(makeCoordinator(mainContext: main.context,
                                                     statusSource: FakeStatusSource(isSyncEnabled: false, clock: clock),
                                                     clock: clock,
                                                     defaults: try makeDefaults()))

        #expect(!safeguard.isStoreEmpty)
        #expect(safeguard.shouldPresentUI)
    }

    @Test("an empty store presents the view when an earlier version was already safeguarded")
    func emptyStorePresentsUIAfterEarlierRun() throws {
        let clock = FakeClock()
        let defaults = try makeDefaults()
        defaults.set("5.0.1 (100)", forKey: Self.versionKey)
        let main = Database(models: [RecordingModel.self], inMemory: true)

        let safeguard = try #require(makeCoordinator(mainContext: main.context,
                                                     statusSource: FakeStatusSource(isSyncEnabled: false, clock: clock),
                                                     clock: clock,
                                                     defaults: defaults))

        #expect(safeguard.isStoreEmpty)
        #expect(safeguard.shouldPresentUI)
    }

    @Test("a nil main context has nothing to protect and stays silent")
    func nilContextRunsSilently() throws {
        let clock = FakeClock()

        let safeguard = try #require(makeCoordinator(statusSource: FakeStatusSource(isSyncEnabled: false, clock: clock),
                                                     clock: clock,
                                                     defaults: try makeDefaults()))

        #expect(safeguard.isStoreEmpty)
        #expect(!safeguard.shouldPresentUI)
    }

    @Test("models that cannot be safeguarded are ignored when judging emptiness")
    func emptinessIgnoresNonSafeguardableModels() throws {
        let clock = FakeClock()
        let main = Database(models: [RecordingModel.self, UnsafeguardedModel.self], inMemory: true)
        main.context.insert(UnsafeguardedModel(key: "1"))
        try main.context.save()

        let safeguard = try #require(makeCoordinator(models: [RecordingModel.self, UnsafeguardedModel.self],
                                                     mainContext: main.context,
                                                     statusSource: FakeStatusSource(isSyncEnabled: false, clock: clock),
                                                     clock: clock,
                                                     defaults: try makeDefaults()))

        #expect(safeguard.isStoreEmpty)
    }

    @Test("the presentation decision survives a fetch that fills the empty store")
    func presentationDecisionIsFrozenAtCreation() async throws {
        let clock = FakeClock()
        let main = Database(models: [RecordingModel.self], inMemory: true)

        let safeguard = try #require(makeCoordinator(
            mainContext: main.context,
            statusSource: FakeStatusSource(isSyncEnabled: false, clock: clock),
            clock: clock,
            defaults: try makeDefaults(),
            fetch: {
                main.context.insert(RecordingModel(key: "1"))
                try? main.context.save()
            }
        ))
        #expect(!safeguard.shouldPresentUI)

        await safeguard.run()

        #expect(safeguard.phase == .done)
        #expect(!safeguard.isStoreEmpty)
        #expect(!safeguard.shouldPresentUI)
    }

    @Test("a silent run that fails surfaces the view so its actions are reachable")
    func silentFailureSurfacesUI() async throws {
        let clock = FakeClock()

        let safeguard = try #require(makeCoordinator(models: [FailingSnapshotModel.self],
                                                     statusSource: FakeStatusSource(isSyncEnabled: false, clock: clock),
                                                     clock: clock,
                                                     defaults: try makeDefaults()))
        #expect(!safeguard.shouldPresentUI)

        await safeguard.run()

        #expect(safeguard.phase.isFailed)
        #expect(safeguard.shouldPresentUI)
    }
}
