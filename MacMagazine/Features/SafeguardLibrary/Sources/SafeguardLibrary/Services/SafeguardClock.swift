import Foundation

/// The passage of time as the safeguard flow measures it, injected so tests can drive the
/// iCloud wait's hard timeout without ever sleeping.
@MainActor
public protocol SafeguardClock: AnyObject {
    var now: Date { get }
}

public final class SystemSafeguardClock: SafeguardClock {
    public init() {}

    public var now: Date { Date() }
}
