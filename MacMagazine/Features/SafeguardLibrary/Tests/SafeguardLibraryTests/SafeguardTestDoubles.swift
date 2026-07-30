import Foundation
import MacMagazineLibrary
@testable import SafeguardLibrary
import StorageLibrary
import SwiftData

// MARK: - Clock

@MainActor
final class FakeClock: SafeguardClock {
    private(set) var now: Date
    private let start: Date

    var elapsed: TimeInterval { now.timeIntervalSince(start) }

    init(now: Date = Date(timeIntervalSince1970: 0)) {
        self.now = now
        self.start = now
    }

    func advance(by interval: TimeInterval) {
        now = now.addingTimeInterval(interval)
    }
}

// MARK: - Status source

/// Replays scripted status events instead of waiting on CloudKit, advancing ``FakeClock`` by the
/// time each wait would have taken so the hard timeout is exercised without any real sleeping.
@MainActor
final class FakeStatusSource: SafeguardStatusSource {
    struct Event {
        let after: TimeInterval
        let event: SafeguardSyncEvent
    }

    let isSyncEnabled: Bool
    private(set) var currentEvent: SafeguardSyncEvent
    private(set) var callCount = 0

    private var events: [Event]
    private let clock: FakeClock

    init(isSyncEnabled: Bool = true,
         currentEvent: SafeguardSyncEvent = .other,
         events: [Event] = [],
         clock: FakeClock) {
        self.isSyncEnabled = isSyncEnabled
        self.currentEvent = currentEvent
        self.events = events
        self.clock = clock
    }

    func nextEvent(timeout: TimeInterval) async -> SafeguardSyncEvent? {
        callCount += 1

        guard let next = events.first, next.after <= timeout else {
            clock.advance(by: timeout)
            return nil
        }

        events.removeFirst()
        clock.advance(by: next.after)
        currentEvent = next.event
        return next.event
    }
}

// MARK: - Recorders

@MainActor
final class PhaseRecorder {
    private(set) var phases: [SafeguardPhase] = []
    var coordinator: SafeguardCoordinator?

    func record() {
        guard let coordinator else { return }
        phases.append(coordinator.phase)
    }
}

@MainActor
final class CompletionFlag {
    private(set) var isSet = false

    func set() {
        isSet = true
    }
}

// MARK: - Models

struct SafeguardTestError: LocalizedError {
    var errorDescription: String? { "safeguard test failure" }
}

@Model
final class RecordingModel {
    var key: String = ""

    init(key: String = "") {
        self.key = key
    }
}

extension RecordingModel: ModelSafeguardable {
    func copied() -> RecordingModel {
        RecordingModel(key: key)
    }

    static func snapshot(from source: ModelContext?, into destination: ModelContext?) throws {
        guard let source, let destination else { return }
        let data = try source.fetch(FetchDescriptor<RecordingModel>())
        data.forEach { destination.insert($0.copied()) }
        try destination.save()
    }

    static func restore(from snapshot: ModelContext?, into main: ModelContext?) throws {
        guard let snapshot, let main else { return }
        let saved = try snapshot.fetch(FetchDescriptor<RecordingModel>())
        let keys = Set(try main.fetch(FetchDescriptor<RecordingModel>()).map(\.key))
        for record in saved where !keys.contains(record.key) {
            main.insert(record.copied())
        }
        try main.save()
    }
}

@Model
final class FailingSnapshotModel {
    var key: String = ""

    init(key: String = "") {
        self.key = key
    }
}

extension FailingSnapshotModel: ModelSafeguardable {
    func copied() -> FailingSnapshotModel {
        FailingSnapshotModel(key: key)
    }

    static func snapshot(from source: ModelContext?, into destination: ModelContext?) throws {
        throw SafeguardTestError()
    }

    static func restore(from snapshot: ModelContext?, into main: ModelContext?) throws {}
}

@Model
final class FailingRestoreModel {
    var key: String = ""

    init(key: String = "") {
        self.key = key
    }
}

extension FailingRestoreModel: ModelSafeguardable {
    func copied() -> FailingRestoreModel {
        FailingRestoreModel(key: key)
    }

    static func snapshot(from source: ModelContext?, into destination: ModelContext?) throws {}

    static func restore(from snapshot: ModelContext?, into main: ModelContext?) throws {
        throw SafeguardTestError()
    }
}
