import Foundation
import Observation
import StorageLibrary

/// The only three things the safeguard flow needs to tell apart in `Database.DatabaseStatus`.
/// Collapsing the status here also keeps it `Sendable`, which resuming a continuation requires -
/// `DatabaseStatus` is nested in the `@MainActor` `Database`.
public enum SafeguardSyncEvent: Sendable {
    case imported
    case failed
    case other

    public init(_ status: Database.DatabaseStatus) {
        switch status {
        case .done(event: .imported): self = .imported
        case .error: self = .failed
        default: self = .other
        }
    }
}

/// The iCloud sync signal the safeguard flow waits on, injected so tests can script events
/// instead of waiting for real CloudKit notifications.
@MainActor
public protocol SafeguardStatusSource: AnyObject {
    /// `false` when the store syncs nothing - there is no import to wait for.
    var isSyncEnabled: Bool { get }

    var currentEvent: SafeguardSyncEvent { get }

    /// Suspends until the status changes, or returns `nil` once `timeout` seconds elapse.
    func nextEvent(timeout: TimeInterval) async -> SafeguardSyncEvent?
}

/// Bridges `Database.status` to ``SafeguardStatusSource`` with the same one-shot
/// `withObservationTracking` arming `MainViewModel.observeStorageStatus()` uses.
@MainActor
public final class StorageStatusSource: SafeguardStatusSource {
    private let storage: Database

    public let isSyncEnabled: Bool

    public var currentEvent: SafeguardSyncEvent { SafeguardSyncEvent(storage.status) }

    public init(storage: Database, isSyncEnabled: Bool) {
        self.storage = storage
        self.isSyncEnabled = isSyncEnabled
    }

    public func nextEvent(timeout: TimeInterval) async -> SafeguardSyncEvent? {
        let storage = storage
        return await withCheckedContinuation { continuation in
            let resumer = Resumer(continuation)

            withObservationTracking {
                _ = storage.status
            } onChange: {
                Task { @MainActor in resumer.resume(with: SafeguardSyncEvent(storage.status)) }
            }

            Task { @MainActor in
                try? await Task.sleep(for: .seconds(timeout))
                resumer.resume(with: nil)
            }
        }
    }
}

/// `withObservationTracking` and the timeout race each other, and only the first one to arrive
/// may resume the continuation - resuming twice traps.
@MainActor
private final class Resumer {
    private var continuation: CheckedContinuation<SafeguardSyncEvent?, Never>?

    init(_ continuation: CheckedContinuation<SafeguardSyncEvent?, Never>) {
        self.continuation = continuation
    }

    func resume(with event: SafeguardSyncEvent?) {
        continuation?.resume(returning: event)
        continuation = nil
    }
}
