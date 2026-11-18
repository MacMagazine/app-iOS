@testable import FeedLibrary
import Foundation
import Testing

@Suite("WidgetRefreshSchedule Tests")
struct WidgetRefreshScheduleTests {
    private let now = Date(timeIntervalSince1970: 1_700_000_000)

    @Test("Successful fetch refreshes after 30 minutes")
    func successRefreshesAfterThirtyMinutes() {
        let next = WidgetRefreshSchedule.nextRefresh(after: now, succeeded: true)

        #expect(next == now.addingTimeInterval(30 * 60))
        #expect(WidgetRefreshSchedule.successInterval == 30 * 60)
    }

    @Test("Failed or empty fetch refreshes after 15 minutes")
    func failureRefreshesAfterFifteenMinutes() {
        let next = WidgetRefreshSchedule.nextRefresh(after: now, succeeded: false)

        #expect(next == now.addingTimeInterval(15 * 60))
        #expect(WidgetRefreshSchedule.failureInterval == 15 * 60)
    }
}
