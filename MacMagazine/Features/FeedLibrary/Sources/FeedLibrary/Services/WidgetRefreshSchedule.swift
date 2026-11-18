import Foundation

/// When the widget timeline asks WidgetKit to reload next.
public enum WidgetRefreshSchedule {
    public static let successInterval: TimeInterval = 30 * 60
    public static let failureInterval: TimeInterval = 15 * 60

    /// Returns the next refresh date: `successInterval` after a fetch with posts, `failureInterval` otherwise.
    public static func nextRefresh(after now: Date, succeeded: Bool) -> Date {
        now.addingTimeInterval(succeeded ? successInterval : failureInterval)
    }
}
