@testable import FeedLibrary
import Foundation
import StorageLibrary
import SwiftData
import Testing

private struct RestoreCase: Sendable {
    let snapshotFavorite: Bool
    let snapshotFavoriteModifiedAt: Date
    let snapshotRead: Bool
    let snapshotReadModifiedAt: Date
    let mainFavorite: Bool
    let mainFavoriteModifiedAt: Date
    let mainRead: Bool
    let mainReadModifiedAt: Date
    let expectedFavorite: Bool
    let expectedRead: Bool
}

@Suite("FeedDB Safeguard Tests")
@MainActor
struct FeedDBSafeguardTests {

    private func makeStores() -> (main: Database, snapshot: Database) {
        (Database(models: [FeedDB.self], inMemory: true),
         Database(models: [FeedDB.self], inMemory: true))
    }

    // MARK: - copied() Tests

    @Test("copied should reproduce every property including authority timestamps")
    func copiedReproducesEveryProperty() {
        let pubDate = Date(timeIntervalSince1970: 500)
        let favoriteModifiedAt = Date(timeIntervalSince1970: 1000)
        let readModifiedAt = Date(timeIntervalSince1970: 2000)
        let modifiedAt = Date(timeIntervalSince1970: 3000)
        let original = FeedDB(
            postId: "1",
            title: "Title",
            subtitle: "Subtitle",
            pubDate: pubDate,
            author: "Author",
            artworkURL: "artwork.jpg",
            link: "link.com",
            categories: ["Tech", "News"],
            excerpt: "Excerpt",
            fullContent: "Content",
            favorite: true,
            favoriteModifiedAt: favoriteModifiedAt,
            read: true,
            readModifiedAt: readModifiedAt,
            modifiedAt: modifiedAt
        )

        let copy = original.copied()

        #expect(copy.postId == "1")
        #expect(copy.title == "Title")
        #expect(copy.subtitle == "Subtitle")
        #expect(copy.pubDate == pubDate)
        #expect(copy.author == "Author")
        #expect(copy.artworkURL == "artwork.jpg")
        #expect(copy.link == "link.com")
        #expect(copy.categories == ["Tech", "News"])
        #expect(copy.excerpt == "Excerpt")
        #expect(copy.fullContent == "Content")
        #expect(copy.favorite == true)
        #expect(copy.favoriteModifiedAt == favoriteModifiedAt)
        #expect(copy.read == true)
        #expect(copy.readModifiedAt == readModifiedAt)
        #expect(copy.modifiedAt == modifiedAt)
    }

    @Test("copied should return a detached instance")
    func copiedReturnsDetachedInstance() {
        let original = FeedDB(postId: "1", title: "Original")

        let copy = original.copied()
        copy.title = "Changed"

        #expect(original.title == "Original")
        #expect(copy !== original)
    }

    // MARK: - snapshot Tests

    @Test("snapshot should copy every row into the destination store")
    func snapshotCopiesEveryRow() {
        let stores = makeStores()
        stores.main.context.insert(FeedDB(postId: "1", title: "First", favorite: true, favoriteModifiedAt: Date(timeIntervalSince1970: 1000)))
        stores.main.context.insert(FeedDB(postId: "2", title: "Second"))
        stores.main.context.insert(FeedDB(postId: "3", title: "Third", read: true, readModifiedAt: Date(timeIntervalSince1970: 2000)))
        try? stores.main.context.save()

        FeedDB.snapshot(from: stores.main.context, into: stores.snapshot.context)

        let saved = stores.snapshot.fetch(FeedDB.self)
        #expect(saved.count == 3)
        #expect(saved.first { $0.postId == "1" }?.favoriteModifiedAt == Date(timeIntervalSince1970: 1000))
        #expect(saved.first { $0.postId == "3" }?.readModifiedAt == Date(timeIntervalSince1970: 2000))
    }

    @Test("snapshot round-trip should survive the main store being emptied")
    func snapshotRoundTripSurvivesEmptiedMainStore() {
        let stores = makeStores()
        stores.main.context.insert(FeedDB(postId: "1", title: "Favorited", favorite: true, favoriteModifiedAt: Date(timeIntervalSince1970: 1000)))
        try? stores.main.context.save()

        FeedDB.snapshot(from: stores.main.context, into: stores.snapshot.context)
        stores.main.fetch(FeedDB.self).forEach { stores.main.context.delete($0) }
        try? stores.main.context.save()
        FeedDB.restore(from: stores.snapshot.context, into: stores.main.context)

        let restored = stores.main.fetch(FeedDB.self)
        #expect(restored.count == 1)
        #expect(restored.first?.title == "Favorited")
        #expect(restored.first?.favorite == true)
    }

    @Test("snapshot rows should be independent of later main-store edits")
    func snapshotRowsAreIndependentOfMainStore() {
        let stores = makeStores()
        let post = FeedDB(postId: "1", favorite: true, favoriteModifiedAt: Date(timeIntervalSince1970: 1000))
        stores.main.context.insert(post)
        try? stores.main.context.save()

        FeedDB.snapshot(from: stores.main.context, into: stores.snapshot.context)
        post.favorite = false
        try? stores.main.context.save()

        #expect(stores.snapshot.fetch(FeedDB.self).first?.favorite == true)
    }

    @Test("snapshot should handle an empty source store")
    func snapshotHandlesEmptySource() {
        let stores = makeStores()

        FeedDB.snapshot(from: stores.main.context, into: stores.snapshot.context)

        #expect(stores.snapshot.fetch(FeedDB.self).isEmpty)
    }

    @Test("snapshot with nil contexts does not crash")
    func snapshotNilContexts() {
        let stores = makeStores()
        FeedDB.snapshot(from: nil, into: stores.snapshot.context)
        FeedDB.snapshot(from: stores.main.context, into: nil)
        #expect(stores.snapshot.fetch(FeedDB.self).isEmpty)
    }

    // MARK: - restore Merge Matrix Tests

    @Test(
        "restore merges favorite and read only when the snapshot timestamp is strictly newer",
        arguments: [
            RestoreCase(
                snapshotFavorite: true, snapshotFavoriteModifiedAt: Date(timeIntervalSince1970: 2000), snapshotRead: true, snapshotReadModifiedAt: Date(timeIntervalSince1970: 2000),
                mainFavorite: false, mainFavoriteModifiedAt: Date(timeIntervalSince1970: 1000), mainRead: false, mainReadModifiedAt: Date(timeIntervalSince1970: 1000),
                expectedFavorite: true, expectedRead: true
            ),
            RestoreCase(
                snapshotFavorite: true, snapshotFavoriteModifiedAt: Date(timeIntervalSince1970: 1000), snapshotRead: true, snapshotReadModifiedAt: Date(timeIntervalSince1970: 1000),
                mainFavorite: false, mainFavoriteModifiedAt: Date(timeIntervalSince1970: 2000), mainRead: false, mainReadModifiedAt: Date(timeIntervalSince1970: 2000),
                expectedFavorite: false, expectedRead: false
            ),
            RestoreCase(
                snapshotFavorite: true, snapshotFavoriteModifiedAt: Date(timeIntervalSince1970: 1000), snapshotRead: true, snapshotReadModifiedAt: Date(timeIntervalSince1970: 1000),
                mainFavorite: false, mainFavoriteModifiedAt: Date(timeIntervalSince1970: 1000), mainRead: false, mainReadModifiedAt: Date(timeIntervalSince1970: 1000),
                expectedFavorite: false, expectedRead: false
            ),
            RestoreCase(
                snapshotFavorite: true, snapshotFavoriteModifiedAt: Date(timeIntervalSince1970: 2000), snapshotRead: false, snapshotReadModifiedAt: Date(timeIntervalSince1970: 1000),
                mainFavorite: false, mainFavoriteModifiedAt: Date(timeIntervalSince1970: 1000), mainRead: true, mainReadModifiedAt: Date(timeIntervalSince1970: 2000),
                expectedFavorite: true, expectedRead: true
            ),
            RestoreCase(
                snapshotFavorite: true, snapshotFavoriteModifiedAt: Date(timeIntervalSince1970: 1000), snapshotRead: true, snapshotReadModifiedAt: Date(timeIntervalSince1970: 1000),
                mainFavorite: false, mainFavoriteModifiedAt: .distantPast, mainRead: false, mainReadModifiedAt: .distantPast,
                expectedFavorite: true, expectedRead: true
            )
        ]
    )
    fileprivate func restoreMergesByAuthorityTimestamp(_ testCase: RestoreCase) {
        let stores = makeStores()
        stores.main.context.insert(FeedDB(postId: "1",
                                          favorite: testCase.mainFavorite,
                                          favoriteModifiedAt: testCase.mainFavoriteModifiedAt,
                                          read: testCase.mainRead,
                                          readModifiedAt: testCase.mainReadModifiedAt))
        stores.snapshot.context.insert(FeedDB(postId: "1",
                                              favorite: testCase.snapshotFavorite,
                                              favoriteModifiedAt: testCase.snapshotFavoriteModifiedAt,
                                              read: testCase.snapshotRead,
                                              readModifiedAt: testCase.snapshotReadModifiedAt))
        try? stores.main.context.save()
        try? stores.snapshot.context.save()

        FeedDB.restore(from: stores.snapshot.context, into: stores.main.context)

        let restored = stores.main.fetch(FeedDB.self)
        #expect(restored.count == 1)
        #expect(restored.first?.favorite == testCase.expectedFavorite)
        #expect(restored.first?.read == testCase.expectedRead)
    }

    @Test("restore preserves the snapshot's own timestamps instead of stamping now")
    func restorePreservesSnapshotTimestamps() {
        let stores = makeStores()
        let snapshotFavoriteModifiedAt = Date(timeIntervalSince1970: 2000)
        stores.main.context.insert(FeedDB(postId: "1", favorite: false, favoriteModifiedAt: Date(timeIntervalSince1970: 1000)))
        stores.snapshot.context.insert(FeedDB(postId: "1", favorite: true, favoriteModifiedAt: snapshotFavoriteModifiedAt))
        try? stores.main.context.save()
        try? stores.snapshot.context.save()

        FeedDB.restore(from: stores.snapshot.context, into: stores.main.context)

        #expect(stores.main.fetch(FeedDB.self).first?.favoriteModifiedAt == snapshotFavoriteModifiedAt)
    }

    @Test("a restored value loses to a newer value arriving afterwards")
    func restoredValueLosesToNewerRemoteValue() {
        let stores = makeStores()
        stores.main.context.insert(FeedDB(postId: "1", favorite: false, favoriteModifiedAt: Date(timeIntervalSince1970: 1000), modifiedAt: Date(timeIntervalSince1970: 1000)))
        stores.snapshot.context.insert(FeedDB(postId: "1", favorite: true, favoriteModifiedAt: Date(timeIntervalSince1970: 2000)))
        try? stores.main.context.save()
        try? stores.snapshot.context.save()

        FeedDB.restore(from: stores.snapshot.context, into: stores.main.context)
        let remoteUnfavorite = FeedDB(postId: "1", favorite: false, favoriteModifiedAt: Date(timeIntervalSince1970: 3000), modifiedAt: Date(timeIntervalSince1970: 3000))
        stores.main.context.insert(remoteUnfavorite)
        try? stores.main.context.save()
        FeedDB.deduplicate(using: stores.main.context)

        let remaining = stores.main.fetch(FeedDB.self)
        #expect(remaining.count == 1)
        #expect(remaining.first?.favorite == false)
    }

    // MARK: - restore Re-insertion Tests

    @Test("restore re-inserts a snapshot row whose postId is gone from the main store")
    func restoreReinsertsMissingRow() {
        let stores = makeStores()
        let favoriteModifiedAt = Date(timeIntervalSince1970: 1000)
        stores.main.context.insert(FeedDB(postId: "kept", title: "Kept"))
        stores.snapshot.context.insert(FeedDB(postId: "kept", title: "Kept"))
        stores.snapshot.context.insert(FeedDB(postId: "old",
                                              title: "Old Favorite",
                                              fullContent: "Content",
                                              favorite: true,
                                              favoriteModifiedAt: favoriteModifiedAt))
        try? stores.main.context.save()
        try? stores.snapshot.context.save()

        FeedDB.restore(from: stores.snapshot.context, into: stores.main.context)

        let restored = stores.main.fetch(FeedDB.self)
        #expect(restored.count == 2)
        let reinserted = restored.first { $0.postId == "old" }
        #expect(reinserted?.title == "Old Favorite")
        #expect(reinserted?.fullContent == "Content")
        #expect(reinserted?.favorite == true)
        #expect(reinserted?.favoriteModifiedAt == favoriteModifiedAt)
    }

    @Test("restore applies the snapshot to every duplicate row sharing the postId")
    func restoreAppliesToEveryDuplicateRow() {
        let stores = makeStores()
        stores.main.context.insert(FeedDB(postId: "1", title: "Copy A", modifiedAt: Date(timeIntervalSince1970: 1000)))
        stores.main.context.insert(FeedDB(postId: "1", title: "Copy B", modifiedAt: Date(timeIntervalSince1970: 2000)))
        stores.snapshot.context.insert(FeedDB(postId: "1", favorite: true, favoriteModifiedAt: Date(timeIntervalSince1970: 3000)))
        try? stores.main.context.save()
        try? stores.snapshot.context.save()

        FeedDB.restore(from: stores.snapshot.context, into: stores.main.context)

        let restored = stores.main.fetch(FeedDB.self)
        #expect(restored.count == 2)
        #expect(restored.allSatisfy { $0.favorite == true })
    }

    @Test("restore followed by deduplicate keeps a single favorited survivor")
    func restoreThenDeduplicateKeepsFavoritedSurvivor() {
        let stores = makeStores()
        stores.main.context.insert(FeedDB(postId: "1", title: "Copy A", modifiedAt: Date(timeIntervalSince1970: 1000)))
        stores.main.context.insert(FeedDB(postId: "1", title: "Copy B", modifiedAt: Date(timeIntervalSince1970: 2000)))
        stores.snapshot.context.insert(FeedDB(postId: "1", favorite: true, favoriteModifiedAt: Date(timeIntervalSince1970: 3000)))
        try? stores.main.context.save()
        try? stores.snapshot.context.save()

        FeedDB.restore(from: stores.snapshot.context, into: stores.main.context)
        FeedDB.deduplicate(using: stores.main.context)

        let remaining = stores.main.fetch(FeedDB.self)
        #expect(remaining.count == 1)
        #expect(remaining.first?.title == "Copy B")
        #expect(remaining.first?.favorite == true)
    }

    @Test("restore leaves untouched rows the snapshot does not know about")
    func restoreLeavesUnknownRowsUntouched() {
        let stores = makeStores()
        stores.main.context.insert(FeedDB(postId: "fresh", title: "Fetched After Update", read: true, readModifiedAt: Date(timeIntervalSince1970: 5000)))
        try? stores.main.context.save()

        FeedDB.restore(from: stores.snapshot.context, into: stores.main.context)

        let restored = stores.main.fetch(FeedDB.self)
        #expect(restored.count == 1)
        #expect(restored.first?.read == true)
    }

    @Test("restore should handle an empty snapshot store")
    func restoreHandlesEmptySnapshot() {
        let stores = makeStores()

        FeedDB.restore(from: stores.snapshot.context, into: stores.main.context)

        #expect(stores.main.fetch(FeedDB.self).isEmpty)
    }

    @Test("restore with nil contexts does not crash")
    func restoreNilContexts() {
        let stores = makeStores()
        FeedDB.restore(from: nil, into: stores.main.context)
        FeedDB.restore(from: stores.snapshot.context, into: nil)
        #expect(stores.main.fetch(FeedDB.self).isEmpty)
    }
}
