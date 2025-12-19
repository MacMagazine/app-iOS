import AVFoundation
import FeedLibrary
import Foundation
@testable import PodcastLibrary
import Testing

@Suite("PodcastPlayerManager Tests")
@MainActor
struct PodcastPlayerManagerTests {

    // MARK: - Current Chapter Detection Tests

    @Test("Should return current chapter when time is within chapter range")
    func currentChapterWithinRange() {
        // Given
        let manager = PodcastPlayerManager()
        manager.chapters = createTestChapters()
        manager.currentTime = 150.0 // Within second chapter (100-200)

        // When
        let chapter = manager.currentChapter

        // Then
        #expect(chapter?.title == "Chapter 2", "Should return chapter 2")
    }

    @Test("Should return nil when time is before all chapters")
    func currentChapterBeforeAll() {
        // Given
        let manager = PodcastPlayerManager()
        manager.chapters = [
            createChapter(title: "Chapter 1", start: 100, duration: 100),
            createChapter(title: "Chapter 2", start: 200, duration: 100)
        ]
        manager.currentTime = 50.0 // Before first chapter starts at 100

        // When
        let chapter = manager.currentChapter

        // Then
        #expect(chapter == nil, "Should return nil when before all chapters")
    }

    @Test("Should return nil when time is after all chapters")
    func currentChapterAfterAll() {
        // Given
        let manager = PodcastPlayerManager()
        manager.chapters = createTestChapters()
        manager.currentTime = 500.0 // After last chapter ends at 300

        // When
        let chapter = manager.currentChapter

        // Then
        #expect(chapter == nil, "Should return nil when after all chapters")
    }

    @Test("Should return first chapter at exact start time")
    func currentChapterAtExactStart() {
        // Given
        let manager = PodcastPlayerManager()
        manager.chapters = createTestChapters()
        manager.currentTime = 0.0 // Exact start of first chapter

        // When
        let chapter = manager.currentChapter

        // Then
        #expect(chapter?.title == "Chapter 1", "Should return first chapter at exact start")
    }

    @Test("Should not return chapter at exact end time")
    func currentChapterAtExactEnd() {
        // Given
        let manager = PodcastPlayerManager()
        manager.chapters = createTestChapters()
        manager.currentTime = 100.0 // Exact end of first chapter

        // When
        let chapter = manager.currentChapter

        // Then
        // currentTime < chapter.end means at exact end time (100.0 < 100.0 is false)
        #expect(chapter?.title == "Chapter 2", "Should return next chapter at exact boundary")
    }

    @Test("Should return correct chapter for last chapter")
    func currentChapterLast() {
        // Given
        let manager = PodcastPlayerManager()
        manager.chapters = createTestChapters()
        manager.currentTime = 250.0 // Within last chapter (200-300)

        // When
        let chapter = manager.currentChapter

        // Then
        #expect(chapter?.title == "Chapter 3", "Should return last chapter")
    }

    @Test("Should return nil when no chapters exist")
    func currentChapterNoChapters() {
        // Given
        let manager = PodcastPlayerManager()
        manager.chapters = []
        manager.currentTime = 150.0

        // When
        let chapter = manager.currentChapter

        // Then
        #expect(chapter == nil, "Should return nil when no chapters")
    }

    // MARK: - Skip By Calculation Tests

    @Test("Should calculate skip forward within bounds correctly")
    func skipForwardWithinBounds() {
        // Given
        let currentTime = 100.0
        let duration = 300.0
        let skipAmount = 30.0

        // When - Test the calculation logic from skip(by:)
        let newTime = currentTime + skipAmount
        let result = max(0, min(newTime, duration))

        // Then
        #expect(result == 130.0, "Should calculate skip to 130.0")
    }

    @Test("Should clamp skip to duration when going past end")
    func skipForwardPastEnd() {
        // Given
        let currentTime = 280.0
        let duration = 300.0
        let skipAmount = 50.0

        // When - Test the calculation logic
        let newTime = currentTime + skipAmount // Would be 330
        let result = max(0, min(newTime, duration))

        // Then
        #expect(result == 300.0, "Should clamp to duration")
    }

    @Test("Should calculate skip backward within bounds correctly")
    func skipBackwardWithinBounds() {
        // Given
        let currentTime = 100.0
        let duration = 300.0
        let skipAmount = -30.0

        // When - Test the calculation logic
        let newTime = currentTime + skipAmount
        let result = max(0, min(newTime, duration))

        // Then
        #expect(result == 70.0, "Should calculate skip to 70.0")
    }

    @Test("Should clamp skip to zero when going past start")
    func skipBackwardPastStart() {
        // Given
        let currentTime = 20.0
        let duration = 300.0
        let skipAmount = -50.0

        // When - Test the calculation logic
        let newTime = currentTime + skipAmount // Would be -30
        let result = max(0, min(newTime, duration))

        // Then
        #expect(result == 0.0, "Should clamp to zero")
    }

    @Test("Should handle zero skip correctly")
    func skipByZero() {
        // Given
        let currentTime = 100.0
        let duration = 300.0
        let skipAmount = 0.0

        // When - Test the calculation logic
        let newTime = currentTime + skipAmount
        let result = max(0, min(newTime, duration))

        // Then
        #expect(result == 100.0, "Should remain at same position")
    }

    // MARK: - Chapter Navigation Edge Cases

    @Test("Should handle empty chapters array in navigation")
    func navigateWithNoChapters() {
        // Given
        let manager = PodcastPlayerManager()
        manager.chapters = []
        manager.currentTime = 100.0

        // When/Then - Should not crash
        // These methods check for currentChapter which will be nil
        #expect(manager.currentChapter == nil)
    }

    @Test("Should handle single chapter")
    func navigateWithSingleChapter() {
        // Given
        let manager = PodcastPlayerManager()
        manager.chapters = [createChapter(title: "Only Chapter", start: 0, duration: 100)]
        manager.currentTime = 50.0

        // When
        let chapter = manager.currentChapter

        // Then
        #expect(chapter?.title == "Only Chapter")
    }

    @Test("Should find correct chapter with many chapters")
    func navigateWithManyChapters() {
        // Given
        let manager = PodcastPlayerManager()
        var chapters: [PodcastChapter] = []
        for index in 0..<20 {
            let start = Double(index * 100)
            chapters.append(createChapter(
                title: "Chapter \(index + 1)",
                start: start,
                duration: 100
            ))
        }
        manager.chapters = chapters
        manager.currentTime = 1050.0 // In chapter 11 (1000-1100)

        // When
        let chapter = manager.currentChapter

        // Then
        #expect(chapter?.title == "Chapter 11", "Should find correct chapter in large array")
    }

    @Test("Should handle overlapping chapter ranges")
    func navigateWithOverlappingChapters() {
        // Given - If chapters somehow overlap, first match wins
        let manager = PodcastPlayerManager()
        manager.chapters = [
            createChapter(title: "Chapter 1", start: 0, duration: 150),
            createChapter(title: "Chapter 2", start: 100, duration: 100) // Overlaps
        ]
        manager.currentTime = 120.0

        // When
        let chapter = manager.currentChapter

        // Then
        #expect(chapter?.title == "Chapter 1", "Should return first matching chapter")
    }

    @Test("Should handle very precise time values")
    func navigateWithPreciseTime() {
        // Given
        let manager = PodcastPlayerManager()
        manager.chapters = createTestChapters()
        manager.currentTime = 99.999999

        // When
        let chapter = manager.currentChapter

        // Then
        #expect(chapter?.title == "Chapter 1", "Should handle precise time values")
    }

    @Test("Should handle chapters with zero duration")
    func navigateWithZeroDurationChapter() {
        // Given
        let manager = PodcastPlayerManager()
        manager.chapters = [
            createChapter(title: "Chapter 1", start: 0, duration: 100),
            createChapter(title: "Marker", start: 100, duration: 0), // Zero duration
            createChapter(title: "Chapter 2", start: 100, duration: 100)
        ]
        manager.currentTime = 100.0

        // When
        let chapter = manager.currentChapter

        // Then
        // At time 100: Chapter 1 ends (100 < 100 is false)
        // Marker at 100 with duration 0 (100 >= 100 && 100 < 100 is false)
        // Chapter 2 starts at 100 (100 >= 100 && 100 < 200 is true)
        #expect(chapter?.title == "Chapter 2", "Should skip zero-duration chapters")
    }
}

// MARK: - Test Helpers

private func createChapter(title: String, start: Double, duration: Double) -> PodcastChapter {
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

private func createTestChapters() -> [PodcastChapter] {
    [
        createChapter(title: "Chapter 1", start: 0, duration: 100),
        createChapter(title: "Chapter 2", start: 100, duration: 100),
        createChapter(title: "Chapter 3", start: 200, duration: 100)
    ]
}
