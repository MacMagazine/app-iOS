import Combine
import FeedLibrary
import Foundation
import StorageLibrary
import SwiftData
import WatchKit

@MainActor
final class FeedRootViewModel: ObservableObject {

    @Published private(set) var items: [FeedDB] = []
    @Published private(set) var status: FeedViewModel.Status = .loading
    @Published var selectedIndex: Int = 0
    @Published var showActions: Bool = false
    @Published var selectedPostForDetail: SelectedPost?

    private let feedViewModel: FeedViewModel

    init(feedViewModel: FeedViewModel) {
        self.feedViewModel = feedViewModel
        self.status = feedViewModel.status
    }

    // MARK: - Public API

    func loadInitial() async {
        await loadFromDB()

        if items.isEmpty {
            await refresh()
        } else {
            status = feedViewModel.status
        }
    }

    func refresh() async {
        _ = try? await feedViewModel.getWatchFeed()
        status = feedViewModel.status
        await loadFromDB()
    }

    // MARK: - Private

    private func loadFromDB() async {
        let context = feedViewModel.context

        let sort: [SortDescriptor<FeedDB>] = [
            SortDescriptor(\FeedDB.pubDate, order: .reverse)
        ]

        let descriptor = FetchDescriptor<FeedDB>(sortBy: sort)

        do {
            items = try context.fetch(descriptor)
        } catch {
            items = []
        }

        #if DEBUG
        if let item = items.first {
            debugPrint("item.title:", item.title)
            debugPrint("item.pubDate:", item.pubDate)
            debugPrint("item.artworkURL:", item.artworkURL)
            debugPrint("item.link:", item.link)
        }
        #endif
    }

    func computeSelectedIndexByMidX(items: [FeedDB], positions: [String: CGPoint]) -> Int {
        guard !items.isEmpty else { return 0 }

        let screenMidX = WKInterfaceDevice.current().screenBounds.midX

        var bestIndex = 0
        var bestDistance = CGFloat.greatestFiniteMagnitude

        for (index, item) in items.enumerated() {
            guard let point = positions[item.postId] else { continue }
            let distance = abs(point.x - screenMidX)
            if distance < bestDistance {
                bestDistance = distance
                bestIndex = index
            }
        }

        return bestIndex
    }

    func computeSelectedIndexByMidY(items: [FeedDB], positions: [String: CGPoint]) -> Int {
        guard !items.isEmpty else { return 0 }

        let screenMidY = WKInterfaceDevice.current().screenBounds.midY

        var bestIndex = 0
        var bestDistance = CGFloat.greatestFiniteMagnitude

        for (index, item) in items.enumerated() {
            guard let point = positions[item.postId] else { continue }
            let distance = abs(point.y - screenMidY)
            if distance < bestDistance {
                bestDistance = distance
                bestIndex = index
            }
        }

        return bestIndex
    }

    func clampIndex(_ index: Int, count: Int) -> Int {
        guard count > 0 else { return 0 }
        return min(max(index, 0), count - 1)
    }

    func toggleActions() {
        showActions.toggle()
    }

    func hideActions() {
        showActions = false
    }

    func toggleFavorite(post: FeedDB) {
        let context = feedViewModel.context
        post.favorite.toggle()

        do {
            try context.save()
        } catch {
            #if DEBUG
            debugPrint("Failed to save favorite:", error.localizedDescription)
            #endif
        }

        showActions = true
    }
}

// MARK: - Preview Support

extension FeedRootViewModel {
    static func preview() -> FeedRootViewModel {
        let database = Database(models: [FeedDB.self], inMemory: true)
        let feedVM = FeedViewModel(storage: database)
        let viewModel = FeedRootViewModel(feedViewModel: feedVM)

        viewModel.items = FeedDB.previewItems
        viewModel.status = .done

        return viewModel
    }
}
