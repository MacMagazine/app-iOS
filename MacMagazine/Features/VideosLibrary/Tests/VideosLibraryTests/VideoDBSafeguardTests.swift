import Foundation
import StorageLibrary
import Testing
@testable import VideosLibrary
import YouTubeLibrary

private struct FavoriteRestoreCase: Sendable {
    let snapshotFavorite: Bool
    let mainFavorite: Bool
    let expectedFavorite: Bool
}

@Suite("VideoDB Safeguard Tests")
@MainActor
struct VideoDBSafeguardTests {

    private func makeStores() -> (main: Database, snapshot: Database) {
        (Database(models: [VideoDB.self], inMemory: true),
         Database(models: [VideoDB.self], inMemory: true))
    }

    private func makeVideo(videoId: String,
                           title: String = "Title",
                           favorite: Bool = false,
                           current: Double = 0,
                           modifiedAt: Date = Date(timeIntervalSince1970: 1000)) -> VideoDB {
        VideoDB(artworkURL: "artwork.jpg",
                current: current,
                duration: "PT4M13S",
                favorite: favorite,
                likes: "10",
                pubDate: "2026-07-30T00:00:00Z",
                title: title,
                videoId: videoId,
                views: "100",
                modifiedAt: modifiedAt)
    }

    // MARK: - copied() Tests

    @Test("copied should reproduce every property")
    func copiedReproducesEveryProperty() {
        let modifiedAt = Date(timeIntervalSince1970: 3000)
        let original = makeVideo(videoId: "abc", title: "Video", favorite: true, current: 42.5, modifiedAt: modifiedAt)

        let copy = original.copied()

        #expect(copy.artworkURL == "artwork.jpg")
        #expect(copy.current == 42.5)
        #expect(copy.duration == "PT4M13S")
        #expect(copy.favorite == true)
        #expect(copy.likes == "10")
        #expect(copy.pubDate == "2026-07-30T00:00:00Z")
        #expect(copy.title == "Video")
        #expect(copy.videoId == "abc")
        #expect(copy.views == "100")
        #expect(copy.modifiedAt == modifiedAt)
    }

    @Test("copied should return a detached instance")
    func copiedReturnsDetachedInstance() {
        let original = makeVideo(videoId: "abc", favorite: true)

        let copy = original.copied()
        copy.favorite = false

        #expect(original.favorite == true)
        #expect(copy !== original)
    }

    // MARK: - snapshot Tests

    @Test("snapshot should copy every row into the destination store")
    func snapshotCopiesEveryRow() {
        let stores = makeStores()
        stores.main.context.insert(makeVideo(videoId: "1", favorite: true))
        stores.main.context.insert(makeVideo(videoId: "2", current: 30))
        try? stores.main.context.save()

        VideoDB.snapshot(from: stores.main.context, into: stores.snapshot.context)

        let saved = stores.snapshot.fetch(VideoDB.self)
        #expect(saved.count == 2)
        #expect(saved.first { $0.videoId == "1" }?.favorite == true)
        #expect(saved.first { $0.videoId == "2" }?.current == 30)
    }

    @Test("snapshot should handle an empty source store")
    func snapshotHandlesEmptySource() {
        let stores = makeStores()

        VideoDB.snapshot(from: stores.main.context, into: stores.snapshot.context)

        #expect(stores.snapshot.fetch(VideoDB.self).isEmpty)
    }

    @Test("snapshot with nil contexts does not crash")
    func snapshotNilContexts() {
        let stores = makeStores()
        VideoDB.snapshot(from: nil, into: stores.snapshot.context)
        VideoDB.snapshot(from: stores.main.context, into: nil)
        #expect(stores.snapshot.fetch(VideoDB.self).isEmpty)
    }

    // MARK: - restore Merge Tests

    @Test(
        "restore OR-merges favorite and never un-favorites",
        arguments: [
            FavoriteRestoreCase(snapshotFavorite: true, mainFavorite: false, expectedFavorite: true),
            FavoriteRestoreCase(snapshotFavorite: false, mainFavorite: true, expectedFavorite: true),
            FavoriteRestoreCase(snapshotFavorite: true, mainFavorite: true, expectedFavorite: true),
            FavoriteRestoreCase(snapshotFavorite: false, mainFavorite: false, expectedFavorite: false)
        ]
    )
    fileprivate func restoreOrMergesFavorite(_ testCase: FavoriteRestoreCase) {
        let stores = makeStores()
        stores.main.context.insert(makeVideo(videoId: "1", favorite: testCase.mainFavorite))
        stores.snapshot.context.insert(makeVideo(videoId: "1", favorite: testCase.snapshotFavorite))
        try? stores.main.context.save()
        try? stores.snapshot.context.save()

        VideoDB.restore(from: stores.snapshot.context, into: stores.main.context)

        let restored = stores.main.fetch(VideoDB.self)
        #expect(restored.count == 1)
        #expect(restored.first?.favorite == testCase.expectedFavorite)
    }

    @Test("restore keeps the larger playback position", arguments: [(120.0, 30.0), (30.0, 120.0)])
    func restoreKeepsLargerPlaybackPosition(snapshotCurrent: Double, mainCurrent: Double) {
        let stores = makeStores()
        stores.main.context.insert(makeVideo(videoId: "1", current: mainCurrent))
        stores.snapshot.context.insert(makeVideo(videoId: "1", current: snapshotCurrent))
        try? stores.main.context.save()
        try? stores.snapshot.context.save()

        VideoDB.restore(from: stores.snapshot.context, into: stores.main.context)

        #expect(stores.main.fetch(VideoDB.self).first?.current == 120)
    }

    // MARK: - restore Re-insertion Tests

    @Test("restore re-inserts a snapshot row whose videoId is gone from the main store")
    func restoreReinsertsMissingRow() {
        let stores = makeStores()
        stores.snapshot.context.insert(makeVideo(videoId: "old", title: "Old Video", favorite: true, current: 55))
        try? stores.snapshot.context.save()

        VideoDB.restore(from: stores.snapshot.context, into: stores.main.context)

        let restored = stores.main.fetch(VideoDB.self)
        #expect(restored.count == 1)
        #expect(restored.first?.title == "Old Video")
        #expect(restored.first?.favorite == true)
        #expect(restored.first?.current == 55)
    }

    @Test("restore applies the snapshot to every duplicate row sharing the videoId")
    func restoreAppliesToEveryDuplicateRow() {
        let stores = makeStores()
        stores.main.context.insert(makeVideo(videoId: "1", title: "Copy A", modifiedAt: Date(timeIntervalSince1970: 1000)))
        stores.main.context.insert(makeVideo(videoId: "1", title: "Copy B", modifiedAt: Date(timeIntervalSince1970: 2000)))
        stores.snapshot.context.insert(makeVideo(videoId: "1", favorite: true))
        try? stores.main.context.save()
        try? stores.snapshot.context.save()

        VideoDB.restore(from: stores.snapshot.context, into: stores.main.context)

        let restored = stores.main.fetch(VideoDB.self)
        #expect(restored.count == 2)
        #expect(restored.allSatisfy { $0.favorite == true })
    }

    @Test("restore followed by deduplicate keeps a single favorited survivor")
    func restoreThenDeduplicateKeepsFavoritedSurvivor() {
        let stores = makeStores()
        stores.main.context.insert(makeVideo(videoId: "1", title: "Copy A", modifiedAt: Date(timeIntervalSince1970: 1000)))
        stores.main.context.insert(makeVideo(videoId: "1", title: "Copy B", modifiedAt: Date(timeIntervalSince1970: 2000)))
        stores.snapshot.context.insert(makeVideo(videoId: "1", favorite: true))
        try? stores.main.context.save()
        try? stores.snapshot.context.save()

        VideoDB.restore(from: stores.snapshot.context, into: stores.main.context)
        VideoDB.deduplicate(using: stores.main.context)

        let remaining = stores.main.fetch(VideoDB.self)
        #expect(remaining.count == 1)
        #expect(remaining.first?.title == "Copy B")
        #expect(remaining.first?.favorite == true)
    }

    @Test("restore should handle an empty snapshot store")
    func restoreHandlesEmptySnapshot() {
        let stores = makeStores()

        VideoDB.restore(from: stores.snapshot.context, into: stores.main.context)

        #expect(stores.main.fetch(VideoDB.self).isEmpty)
    }

    @Test("restore with nil contexts does not crash")
    func restoreNilContexts() {
        let stores = makeStores()
        VideoDB.restore(from: nil, into: stores.main.context)
        VideoDB.restore(from: stores.snapshot.context, into: nil)
        #expect(stores.main.fetch(VideoDB.self).isEmpty)
    }
}
