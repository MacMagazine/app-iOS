@testable import FeedLibrary
import Foundation
import StorageLibrary
import SwiftData
import Testing

private struct ProgressRestoreCase: Sendable {
    let snapshotCurrent: Double
    let snapshotProgressModifiedAt: Date
    let mainCurrent: Double
    let mainProgressModifiedAt: Date
    let expectedCurrent: Double
}

@Suite("PodcastDB Safeguard Tests")
@MainActor
struct PodcastDBSafeguardTests {

    private func makeStores() -> (main: Database, snapshot: Database) {
        (Database(models: [PodcastDB.self], inMemory: true),
         Database(models: [PodcastDB.self], inMemory: true))
    }

    // MARK: - copied() Tests

    @Test("copied should reproduce every property including authority timestamps")
    func copiedReproducesEveryProperty() {
        let pubDate = Date(timeIntervalSince1970: 500)
        let favoriteModifiedAt = Date(timeIntervalSince1970: 1000)
        let progressModifiedAt = Date(timeIntervalSince1970: 2000)
        let modifiedAt = Date(timeIntervalSince1970: 3000)
        let original = PodcastDB(
            postId: "1",
            title: "Title",
            subtitle: "Subtitle",
            pubDate: pubDate,
            artworkURL: "artwork.jpg",
            link: "link.com",
            podcastURL: "podcast.mp3",
            podcastSize: 1024,
            duration: "01:02:03",
            podcastFrame: "<iframe>",
            favorite: true,
            favoriteModifiedAt: favoriteModifiedAt,
            playable: true,
            current: 42.5,
            progressModifiedAt: progressModifiedAt,
            modifiedAt: modifiedAt
        )

        let copy = original.copied()

        #expect(copy.postId == "1")
        #expect(copy.title == "Title")
        #expect(copy.subtitle == "Subtitle")
        #expect(copy.pubDate == pubDate)
        #expect(copy.artworkURL == "artwork.jpg")
        #expect(copy.link == "link.com")
        #expect(copy.podcastURL == "podcast.mp3")
        #expect(copy.podcastSize == 1024)
        #expect(copy.duration == "01:02:03")
        #expect(copy.podcastFrame == "<iframe>")
        #expect(copy.favorite == true)
        #expect(copy.favoriteModifiedAt == favoriteModifiedAt)
        #expect(copy.playable == true)
        #expect(copy.current == 42.5)
        #expect(copy.progressModifiedAt == progressModifiedAt)
        #expect(copy.modifiedAt == modifiedAt)
    }

    @Test("copied should return a detached instance")
    func copiedReturnsDetachedInstance() {
        let original = PodcastDB(postId: "1", current: 10)

        let copy = original.copied()
        copy.current = 99

        #expect(original.current == 10)
        #expect(copy !== original)
    }

    // MARK: - snapshot Tests

    @Test("snapshot should copy every row into the destination store")
    func snapshotCopiesEveryRow() throws {
        let stores = makeStores()
        stores.main.context.insert(PodcastDB(postId: "1", favorite: true, favoriteModifiedAt: Date(timeIntervalSince1970: 1000)))
        stores.main.context.insert(PodcastDB(postId: "2", current: 33, progressModifiedAt: Date(timeIntervalSince1970: 2000)))
        try? stores.main.context.save()

        try PodcastDB.snapshot(from: stores.main.context, into: stores.snapshot.context)

        let saved = stores.snapshot.fetch(PodcastDB.self)
        #expect(saved.count == 2)
        #expect(saved.first { $0.postId == "1" }?.favoriteModifiedAt == Date(timeIntervalSince1970: 1000))
        #expect(saved.first { $0.postId == "2" }?.current == 33)
    }

    @Test("snapshot should handle an empty source store")
    func snapshotHandlesEmptySource() throws {
        let stores = makeStores()

        try PodcastDB.snapshot(from: stores.main.context, into: stores.snapshot.context)

        #expect(stores.snapshot.fetch(PodcastDB.self).isEmpty)
    }

    @Test("snapshot with nil contexts does not crash")
    func snapshotNilContexts() throws {
        let stores = makeStores()
        try PodcastDB.snapshot(from: nil, into: stores.snapshot.context)
        try PodcastDB.snapshot(from: stores.main.context, into: nil)
        #expect(stores.snapshot.fetch(PodcastDB.self).isEmpty)
    }

    // MARK: - restore Merge Tests

    @Test(
        "restore merges playback progress only when the snapshot timestamp is strictly newer",
        arguments: [
            ProgressRestoreCase(snapshotCurrent: 120, snapshotProgressModifiedAt: Date(timeIntervalSince1970: 2000),
                                mainCurrent: 10, mainProgressModifiedAt: Date(timeIntervalSince1970: 1000),
                                expectedCurrent: 120),
            ProgressRestoreCase(snapshotCurrent: 120, snapshotProgressModifiedAt: Date(timeIntervalSince1970: 1000),
                                mainCurrent: 10, mainProgressModifiedAt: Date(timeIntervalSince1970: 2000),
                                expectedCurrent: 10),
            ProgressRestoreCase(snapshotCurrent: 120, snapshotProgressModifiedAt: Date(timeIntervalSince1970: 1000),
                                mainCurrent: 10, mainProgressModifiedAt: Date(timeIntervalSince1970: 1000),
                                expectedCurrent: 10),
            ProgressRestoreCase(snapshotCurrent: 120, snapshotProgressModifiedAt: Date(timeIntervalSince1970: 1000),
                                mainCurrent: 0, mainProgressModifiedAt: .distantPast,
                                expectedCurrent: 120)
        ]
    )
    fileprivate func restoreMergesProgressByAuthorityTimestamp(_ testCase: ProgressRestoreCase) throws {
        let stores = makeStores()
        stores.main.context.insert(PodcastDB(postId: "1", current: testCase.mainCurrent, progressModifiedAt: testCase.mainProgressModifiedAt))
        stores.snapshot.context.insert(PodcastDB(postId: "1", current: testCase.snapshotCurrent, progressModifiedAt: testCase.snapshotProgressModifiedAt))
        try? stores.main.context.save()
        try? stores.snapshot.context.save()

        try PodcastDB.restore(from: stores.snapshot.context, into: stores.main.context)

        let restored = stores.main.fetch(PodcastDB.self)
        #expect(restored.count == 1)
        #expect(restored.first?.current == testCase.expectedCurrent)
    }

    @Test("restore merges favorite and progress independently by their own timestamps")
    func restoreMergesFavoriteAndProgressIndependently() throws {
        let stores = makeStores()
        stores.main.context.insert(PodcastDB(postId: "1",
                                             favorite: false,
                                             favoriteModifiedAt: Date(timeIntervalSince1970: 1000),
                                             current: 90,
                                             progressModifiedAt: Date(timeIntervalSince1970: 3000)))
        stores.snapshot.context.insert(PodcastDB(postId: "1",
                                                 favorite: true,
                                                 favoriteModifiedAt: Date(timeIntervalSince1970: 2000),
                                                 current: 15,
                                                 progressModifiedAt: Date(timeIntervalSince1970: 2000)))
        try? stores.main.context.save()
        try? stores.snapshot.context.save()

        try PodcastDB.restore(from: stores.snapshot.context, into: stores.main.context)

        let restored = stores.main.fetch(PodcastDB.self).first
        #expect(restored?.favorite == true)
        #expect(restored?.current == 90)
    }

    @Test("restore preserves the snapshot's own timestamps instead of stamping now")
    func restorePreservesSnapshotTimestamps() throws {
        let stores = makeStores()
        let progressModifiedAt = Date(timeIntervalSince1970: 2000)
        stores.main.context.insert(PodcastDB(postId: "1", current: 0, progressModifiedAt: Date(timeIntervalSince1970: 1000)))
        stores.snapshot.context.insert(PodcastDB(postId: "1", current: 75, progressModifiedAt: progressModifiedAt))
        try? stores.main.context.save()
        try? stores.snapshot.context.save()

        try PodcastDB.restore(from: stores.snapshot.context, into: stores.main.context)

        #expect(stores.main.fetch(PodcastDB.self).first?.progressModifiedAt == progressModifiedAt)
    }

    // MARK: - restore Re-insertion Tests

    @Test("restore re-inserts a snapshot row whose postId is gone from the main store")
    func restoreReinsertsMissingRow() throws {
        let stores = makeStores()
        stores.snapshot.context.insert(PodcastDB(postId: "old",
                                                 title: "Old Episode",
                                                 podcastURL: "old.mp3",
                                                 favorite: true,
                                                 favoriteModifiedAt: Date(timeIntervalSince1970: 1000),
                                                 current: 200,
                                                 progressModifiedAt: Date(timeIntervalSince1970: 1000)))
        try? stores.snapshot.context.save()

        try PodcastDB.restore(from: stores.snapshot.context, into: stores.main.context)

        let restored = stores.main.fetch(PodcastDB.self)
        #expect(restored.count == 1)
        #expect(restored.first?.title == "Old Episode")
        #expect(restored.first?.podcastURL == "old.mp3")
        #expect(restored.first?.favorite == true)
        #expect(restored.first?.current == 200)
    }

    @Test("restore applies the snapshot to every duplicate row sharing the postId")
    func restoreAppliesToEveryDuplicateRow() throws {
        let stores = makeStores()
        stores.main.context.insert(PodcastDB(postId: "1", title: "Copy A", modifiedAt: Date(timeIntervalSince1970: 1000)))
        stores.main.context.insert(PodcastDB(postId: "1", title: "Copy B", modifiedAt: Date(timeIntervalSince1970: 2000)))
        stores.snapshot.context.insert(PodcastDB(postId: "1", favorite: true, favoriteModifiedAt: Date(timeIntervalSince1970: 3000)))
        try? stores.main.context.save()
        try? stores.snapshot.context.save()

        try PodcastDB.restore(from: stores.snapshot.context, into: stores.main.context)

        let restored = stores.main.fetch(PodcastDB.self)
        #expect(restored.count == 2)
        #expect(restored.allSatisfy { $0.favorite == true })
    }

    @Test("restore should handle an empty snapshot store")
    func restoreHandlesEmptySnapshot() throws {
        let stores = makeStores()

        try PodcastDB.restore(from: stores.snapshot.context, into: stores.main.context)

        #expect(stores.main.fetch(PodcastDB.self).isEmpty)
    }

    @Test("restore with nil contexts does not crash")
    func restoreNilContexts() throws {
        let stores = makeStores()
        try PodcastDB.restore(from: nil, into: stores.main.context)
        try PodcastDB.restore(from: stores.snapshot.context, into: nil)
        #expect(stores.main.fetch(PodcastDB.self).isEmpty)
    }
}
