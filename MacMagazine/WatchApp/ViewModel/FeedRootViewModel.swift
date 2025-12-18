import Combine
import FeedLibrary
import Foundation
import StorageLibrary
import SwiftData
import WatchKit

@MainActor
final class FeedRootViewModel: ObservableObject {

    // MARK: - Published

    @Published private(set) var status: FeedViewModel.Status = .loading
    @Published var selectedIndex: Int = 0
    @Published var showActions: Bool = false
    @Published var showContextMenu: Bool = false
    @Published var selectedPostForDetail: SelectedPost?
    @Published private(set) var isRefreshing: Bool = false

    // MARK: - Private

    private let feedViewModel: FeedViewModel

    // MARK: - Init

    init(feedViewModel: FeedViewModel) {
        self.feedViewModel = feedViewModel
        status = feedViewModel.status
    }

    // MARK: - Public API

    func loadInitial(hasItems: Bool, modelContext: ModelContext) async {
        if hasItems {
            status = .done
            return
        }

        await refresh(modelContext: modelContext)
    }

    func refresh(modelContext: ModelContext) async {
        isRefreshing = true

        defer {
            isRefreshing = false
        }

        _ = try? await feedViewModel.getWatchFeed()
        status = feedViewModel.status
    }

    func toggleFavorite(post: FeedDB, modelContext: ModelContext) {
        post.favorite.toggle()
        try? modelContext.save()
        showActions = true
    }

    // MARK: - Index / Helpers

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

    func clampIndex(_ index: Int, quantity: Int) -> Int {
        guard quantity > 0 else { return 0 }
        return min(max(index, 0), quantity - 1)
    }

    @MainActor
    func setStatusForPreview(_ status: FeedViewModel.Status) {
        self.status = status
    }
}
