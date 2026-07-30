import Foundation
import MacMagazineLibrary
import Observation
import StorageLibrary
import SwiftData
import UtilityLibrary

@MainActor
@Observable
public final class SafeguardCoordinator: @MainActor Identifiable {
    public var id: String { "safeguard" }

    // Current flow state
    public private(set) var phase: SafeguardPhase = .snapshotting

    /// The in-memory working copy of the user's pre-flow state. Released only once a restore has
    /// succeeded: after a failure it is the only copy of that state left, so it is deliberately
    /// kept alive for ``retry()``.
    public private(set) var snapshot: Database?

    // Completion callback
    public var onComplete: (() -> Void)?

    // Dependencies
    private let models: [any PersistentModel.Type]
    private let mainContext: ModelContext?
    private let statusSource: SafeguardStatusSource
    private let clock: SafeguardClock
    private let defaults: UserDefaults
    private let version: String
    private let fetch: @MainActor () async -> Void
    private let deduplicate: @MainActor () -> Void

    // Wait windows
    static let quiesceWindow: TimeInterval = 5
    static let hardTimeout: TimeInterval = 30

    // UserDefaults keys
    private static let lastSafeguardedVersionKey = "lastSafeguardedVersion"

    public init(
        models: [any PersistentModel.Type],
        mainContext: ModelContext?,
        statusSource: SafeguardStatusSource,
        clock: SafeguardClock,
        defaults: UserDefaults,
        version: String,
        fetch: @escaping @MainActor () async -> Void,
        deduplicate: @escaping @MainActor () -> Void
    ) {
        self.models = models
        self.mainContext = mainContext
        self.statusSource = statusSource
        self.clock = clock
        self.defaults = defaults
        self.version = version
        self.fetch = fetch
        self.deduplicate = deduplicate
    }

    // MARK: - Flow

    public func run() async {
        do {
            try takeSnapshot()

            phase = .waitingForICloud
            await waitForICloud()

            phase = .fetching
            await fetch()

            try applySnapshot()
        } catch {
            phase = .failed(error.localizedDescription)
        }
    }

    /// Re-attempts the restore against the snapshot a failed run left behind.
    public func retry() async {
        do {
            try applySnapshot()
        } catch {
            phase = .failed(error.localizedDescription)
        }
    }

    private func takeSnapshot() throws {
        phase = .snapshotting

        let store = snapshot ?? Database(models: models, appGroupID: nil, inMemory: true)
        snapshot = store

        for model in models {
            try (model as? any ModelSafeguardable.Type)?.snapshot(from: mainContext, into: store.context)
        }
    }

    private func applySnapshot() throws {
        phase = .restoring

        guard let store = snapshot else { return }
        for model in models {
            try (model as? any ModelSafeguardable.Type)?.restore(from: store.context, into: mainContext)
        }
        deduplicate()

        finalize()
    }

    /// Writes the version key only here, once the data is safely back: a run that dies earlier
    /// leaves the key untouched and simply repeats on the next launch.
    private func finalize() {
        defaults.set(version, forKey: Self.lastSafeguardedVersionKey)
        snapshot = nil
        phase = .done
        onComplete?()
    }

    // MARK: - iCloud Wait

    /// Lets iCloud settle before the restore reads the store: waits for `.done(.imported)` and
    /// then for `quiesceWindow` seconds without any further event, giving up at `hardTimeout`.
    /// An `.error`, a store that syncs nothing, and the timeout all proceed immediately - the
    /// restore's authority timestamps stay correct whether or not the import finished.
    private func waitForICloud() async {
        guard statusSource.isSyncEnabled, statusSource.currentEvent != .failed else { return }

        let deadline = clock.now.addingTimeInterval(Self.hardTimeout)
        var hasImported = statusSource.currentEvent == .imported

        while clock.now < deadline {
            let remaining = deadline.timeIntervalSince(clock.now)
            let budget = hasImported ? min(Self.quiesceWindow, remaining) : remaining

            guard let event = await statusSource.nextEvent(timeout: budget) else { return }
            if event == .failed { return }
            hasImported = hasImported || event == .imported
        }
    }

    // MARK: - Version Gate

    /// `CFBundleShortVersionString` alongside `CFBundleVersion`, so a build-only bump reads as a
    /// changed version and fires the flow too.
    public static var currentVersion: String {
        "\(Bundle.version ?? "") (\(Bundle.build ?? ""))"
    }

    /// Create coordinator if the safeguard is needed, returns nil if not needed
    public static func createIfNeeded(
        models: [any PersistentModel.Type],
        mainContext: ModelContext?,
        statusSource: SafeguardStatusSource,
        clock: SafeguardClock = SystemSafeguardClock(),
        defaults: UserDefaults = .standard,
        version: String = SafeguardCoordinator.currentVersion,
        fetch: @escaping @MainActor () async -> Void,
        deduplicate: @escaping @MainActor () -> Void
    ) -> SafeguardCoordinator? {
        guard defaults.string(forKey: lastSafeguardedVersionKey) != version else { return nil }

        return SafeguardCoordinator(
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

    /// Reset safeguard state (for debug/testing)
    public static func resetSafeguard(defaults: UserDefaults = .standard) {
        defaults.removeObject(forKey: lastSafeguardedVersionKey)
    }
}

// MARK: - Safeguard Phase Enum

public enum SafeguardPhase: Hashable, Sendable {
    case snapshotting
    case waitingForICloud
    case fetching
    case restoring
    case done
    case failed(String)
}
