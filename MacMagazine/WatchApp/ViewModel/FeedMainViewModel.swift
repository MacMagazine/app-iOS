import FeedLibrary
import Foundation
import StorageLibrary
import SwiftData
import WatchKit
import WidgetKit

@MainActor
@Observable
final class FeedMainViewModel {

    // MARK: - Published

    private(set) var status: FeedViewModel.Status = .loading
    var selectedIndex: Int = 0
    var showContextMenu: Bool = false
    var selectedPostForDetail: FeedDB?
    private(set) var isRefreshing: Bool = false

    // MARK: - Private

    private let feedViewModel: FeedViewModel

    // MARK: - Init

    init(feedViewModel: FeedViewModel) {
        self.feedViewModel = feedViewModel
        status = feedViewModel.status
    }

    // MARK: - Public API

    func refresh(modelContext: ModelContext) async {
        guard !isRefreshing else { return }
        isRefreshing = true
        defer { isRefreshing = false }

        _ = try? await feedViewModel.getWatchFeed()
        status = feedViewModel.status

        WidgetCenter.shared.reloadAllTimelines()
    }

    func toggleFavorite(post: FeedDB, modelContext: ModelContext) {
        post.favorite.toggle()
        try? modelContext.save()
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

     func openPost(withId postId: String, modelContext: ModelContext) {
        let predicate = #Predicate<FeedDB> { $0.postId == postId }
        let descriptor = FetchDescriptor<FeedDB>(predicate: predicate)

         if let post = try? modelContext.fetch(descriptor).first {
             selectedPostForDetail = post
         }
    }
}

#if DEBUG
extension FeedMainViewModel {
    @MainActor
    func setStatusForPreview(_ status: FeedViewModel.Status) {
        self.status = status
    }
}
#endif
