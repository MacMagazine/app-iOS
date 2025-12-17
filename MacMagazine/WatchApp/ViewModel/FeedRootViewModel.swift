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
    @Published var selectedPostForDetail: SelectedPost?

    // MARK: - Private

    private let feedViewModel: FeedViewModel

    // MARK: - Init

    init(feedViewModel: FeedViewModel) {
        self.feedViewModel = feedViewModel
        status = feedViewModel.status
    }

    // MARK: - Public API

    func loadInitial(hasItems: Bool) async {
        if !hasItems {
            await refresh()
        } else {
            status = feedViewModel.status
        }
    }

    func refresh() async {
        _ = try? await feedViewModel.getWatchFeed()
        status = feedViewModel.status
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
        try? context.save()
        showActions = true
    }

    // MARK: - Index Calculation

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

    func clampIndex(_ index: Int, quantity: Int) -> Int {
        guard quantity > 0 else { return 0 }
        return min(max(index, 0), quantity - 1)
    }
}

// MARK: - Preview Support

#if DEBUG
extension FeedRootViewModel {
    static func preview() -> FeedRootViewModel {
        let database = Database(models: [FeedDB.self], inMemory: true)
        let feedVM = FeedViewModel(storage: database)
        let viewModel = FeedRootViewModel(feedViewModel: feedVM)

        viewModel.status = .done

        return viewModel
    }
}
#endif
