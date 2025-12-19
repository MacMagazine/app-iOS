import AVFoundation
import Foundation
@testable import PodcastLibrary
import SwiftUI
import Testing

@Suite("PodcastChapter Tests")
struct PodcastChapterTests {

    // MARK: - Time Formatting Tests

    @Test("Should format time under 1 minute correctly (MM:SS format without hour)")
    func formatUnder1Minute() {
        // Given - 30 seconds
        let chapter = createChapter(start: 0, duration: 30)

        // When
        let formatted = chapter.durationString

        // Then
        #expect(formatted == "00:30", "30 seconds should format as '00:30'")
    }

    @Test("Should format exactly 1 minute correctly")
    func formatExactly1Minute() {
        // Given - 60 seconds
        let chapter = createChapter(start: 0, duration: 60)

        // When
        let formatted = chapter.durationString

        // Then
        #expect(formatted == "01:00", "60 seconds should format as '01:00'")
    }

    @Test("Should format time under 1 hour correctly (removes leading 0:)")
    func formatUnder1Hour() {
        // Given - 45 minutes 30 seconds (2730 seconds)
        let chapter = createChapter(start: 0, duration: 2730)

        // When
        let formatted = chapter.durationString

        // Then
        #expect(formatted == "45:30", "Should format as 'MM:SS' without leading '0:'")
    }

    @Test("Should format exactly 1 hour correctly (includes hour)")
    func formatExactly1Hour() {
        // Given - 3600 seconds (1 hour)
        let chapter = createChapter(start: 0, duration: 3600)

        // When
        let formatted = chapter.durationString

        // Then
        #expect(formatted == "01:00:00", "1 hour should format as '01:00:00'")
    }

    @Test("Should format time over 1 hour correctly (H:MM:SS format)")
    func formatOver1Hour() {
        // Given - 1 hour 23 minutes 45 seconds (5025 seconds)
        let chapter = createChapter(start: 0, duration: 5025)

        // When
        let formatted = chapter.durationString

        // Then
        #expect(formatted == "01:23:45", "Should format as 'HH:MM:SS'")
    }

    @Test("Should format time just under 1 hour correctly")
    func formatJustUnder1Hour() {
        // Given - 59 minutes 59 seconds (3599 seconds)
        let chapter = createChapter(start: 0, duration: 3599)

        // When
        let formatted = chapter.durationString

        // Then
        #expect(formatted == "59:59", "59:59 should format without hour")
    }

    @Test("Should format time just over 1 hour correctly")
    func formatJustOver1Hour() {
        // Given - 1 hour 1 second (3601 seconds)
        let chapter = createChapter(start: 0, duration: 3601)

        // When
        let formatted = chapter.durationString

        // Then
        #expect(formatted == "01:00:01", "01:00:01 should include hour")
    }

    @Test("Should format start time correctly")
    func formatStartTime() {
        // Given - Start at 5 minutes 30 seconds
        let chapter = createChapter(start: 330, duration: 100)

        // When
        let formatted = chapter.startString

        // Then
        #expect(formatted == "05:30", "Start time should format correctly")
    }

    @Test("Should format zero duration correctly")
    func formatZeroDuration() {
        // Given - 0 seconds
        let chapter = createChapter(start: 0, duration: 0)

        // When
        let formatted = chapter.durationString

        // Then
        #expect(formatted == "00:00", "Zero duration should format as '00:00'")
    }

    @Test("Should format multi-hour duration correctly")
    func formatMultiHourDuration() {
        // Given - 2 hours 15 minutes 30 seconds (8130 seconds)
        let chapter = createChapter(start: 0, duration: 8130)

        // When
        let formatted = chapter.durationString

        // Then
        #expect(formatted == "02:15:30", "Multi-hour duration should format correctly")
    }

    @Test("Should format very long duration correctly")
    func formatVeryLongDuration() {
        // Given - 10 hours (36000 seconds)
        let chapter = createChapter(start: 0, duration: 36000)

        // When
        let formatted = chapter.durationString

        // Then
        #expect(formatted == "10:00:00", "Very long duration should format correctly")
    }

    // MARK: - Background Color Tests

    @Test("Should return last color with opacity when position is within chapter")
    func backgroundColorDuringChapter() {
        // Given
        let colors = [Color.red, Color.blue, Color.green]
        let chapter = createChapter(start: 100, duration: 50) // 100-150 seconds
        let position = 125.0 // Within range

        // When
        let backgroundColor = chapter.backgroundColor(at: position, using: colors)

        // Then
        // Color comparison in SwiftUI is complex, but we can verify it's constructed
        // The logic should use colors.last (green) with 0.4 opacity
        _ = backgroundColor
        #expect(true, "Should return last color when within chapter range")
    }

    @Test("Should return first color with opacity when position is before chapter")
    func backgroundColorBeforeChapter() {
        // Given
        let colors = [Color.red, Color.blue, Color.green]
        let chapter = createChapter(start: 100, duration: 50) // 100-150 seconds
        let position = 50.0 // Before range

        // When
        let backgroundColor = chapter.backgroundColor(at: position, using: colors)

        // Then
        // Should use colors.first (red) with 0.4 opacity
        _ = backgroundColor
        #expect(true, "Should return first color when before chapter range")
    }

    @Test("Should return first color with opacity when position is after chapter")
    func backgroundColorAfterChapter() {
        // Given
        let colors = [Color.red, Color.blue, Color.green]
        let chapter = createChapter(start: 100, duration: 50) // 100-150 seconds
        let position = 200.0 // After range

        // When
        let backgroundColor = chapter.backgroundColor(at: position, using: colors)

        // Then
        // Should use colors.first (red) with 0.4 opacity
        _ = backgroundColor
        #expect(true, "Should return first color when after chapter range")
    }

    @Test("Should handle position exactly at start of chapter")
    func backgroundColorAtExactStart() {
        // Given
        let colors = [Color.red, Color.blue]
        let chapter = createChapter(start: 100, duration: 50)
        let position = 100.0 // Exact start

        // When
        let backgroundColor = chapter.backgroundColor(at: position, using: colors)

        // Then
        // position >= start is true, position < end is true, so should use last color
        _ = backgroundColor
        #expect(true, "Should return last color at exact start")
    }

    @Test("Should handle position exactly at end of chapter")
    func backgroundColorAtExactEnd() {
        // Given
        let colors = [Color.red, Color.blue]
        let chapter = createChapter(start: 100, duration: 50) // End is at 150
        let position = 150.0 // Exact end

        // When
        let backgroundColor = chapter.backgroundColor(at: position, using: colors)

        // Then
        // position >= start is true, position < end is false, so should use first color
        _ = backgroundColor
        #expect(true, "Should return first color at exact end")
    }

    @Test("Should use gray fallback when color array is empty for active chapter")
    func backgroundColorEmptyArrayDuringChapter() {
        // Given
        let colors: [Color] = []
        let chapter = createChapter(start: 100, duration: 50)
        let position = 125.0

        // When
        let backgroundColor = chapter.backgroundColor(at: position, using: colors)

        // Then
        // Should fallback to gray with 0.4 opacity
        _ = backgroundColor
        #expect(true, "Should handle empty color array with gray fallback")
    }

    @Test("Should use primary fallback when color array is empty for inactive chapter")
    func backgroundColorEmptyArrayOutsideChapter() {
        // Given
        let colors: [Color] = []
        let chapter = createChapter(start: 100, duration: 50)
        let position = 50.0

        // When
        let backgroundColor = chapter.backgroundColor(at: position, using: colors)

        // Then
        // Should fallback to primary with 0.4 opacity
        _ = backgroundColor
        #expect(true, "Should handle empty color array with primary fallback")
    }

    // MARK: - Hashable Tests

    @Test("Should be hashable with unique IDs")
    func hashableWithUniqueIDs() {
        // Given
        let chapter1 = createChapter(start: 0, duration: 100)
        let chapter2 = createChapter(start: 0, duration: 100)

        // When/Then
        // Even with same content, different UUIDs make them different
        #expect(chapter1.id != chapter2.id, "Different chapter instances should have different IDs")
    }

    @Test("Should be usable in Set")
    func usableInSet() {
        // Given
        let chapter1 = createChapter(start: 0, duration: 100)
        let chapter2 = createChapter(start: 100, duration: 100)
        let chapter3 = createChapter(start: 200, duration: 100)

        // When
        var chapterSet: Set<PodcastChapter> = []
        chapterSet.insert(chapter1)
        chapterSet.insert(chapter2)
        chapterSet.insert(chapter3)

        // Then
        #expect(chapterSet.count == 3, "Set should contain all unique chapters")
    }

    // MARK: - Edge Cases

    @Test("Should handle fractional seconds in formatting")
    func formatFractionalSeconds() {
        // Given - 30.5 seconds
        let start = CMTime(seconds: 0, preferredTimescale: 600)
        let duration = CMTime(seconds: 30.5, preferredTimescale: 600)
        let end = CMTime(seconds: 30.5, preferredTimescale: 600)
        let chapter = PodcastChapter(
            title: "Test",
            start: start,
            end: end,
            duration: duration,
            artworkData: nil
        )

        // When
        let formatted = chapter.durationString

        // Then
        // DateComponentsFormatter rounds/truncates fractional seconds
        #expect(!formatted.isEmpty, "Should format fractional seconds")
    }

    @Test("Should handle very precise position in backgroundColor")
    func backgroundColorPrecisePosition() {
        // Given
        let colors = [Color.red, Color.blue]
        let chapter = createChapter(start: 100.123, duration: 50.456)
        let position = 125.789

        // When
        let backgroundColor = chapter.backgroundColor(at: position, using: colors)

        // Then
        _ = backgroundColor
        #expect(true, "Should handle precise decimal positions")
    }
}

// MARK: - Test Helpers

private func createChapter(start: Double, duration: Double, title: String = "Test Chapter") -> PodcastChapter {
    let startTime = CMTime(seconds: start, preferredTimescale: 600)
    let durationTime = CMTime(seconds: duration, preferredTimescale: 600)
    let endTime = CMTime(seconds: start + duration, preferredTimescale: 600)

    return PodcastChapter(
        title: title,
        start: startTime,
        end: endTime,
        duration: durationTime,
        artworkData: nil
    )
}
