import Combine
import FeedLibrary
import Foundation
import StorageLibrary
import SwiftData
import WatchKit
import WidgetKit

@MainActor
final class FeedMainViewModel: ObservableObject {

    // MARK: - Published

    @Published private(set) var status: FeedViewModel.Status = .loading
    @Published var selectedIndex: Int = 0
    @Published var showActions: Bool = false
    @Published var showContextMenu: Bool = false
    @Published var selectedPostForDetail: SelectedPost?
    @Published private(set) var isRefreshing: Bool = false

    // MARK: - Private

    private let feedViewModel: FeedViewModel
    private var didLoadInitial: Bool = false
    private var lastRefreshAt: Date?
    private let staleInterval: TimeInterval = 30 * 60

    // MARK: - Init

    init(feedViewModel: FeedViewModel) {
        self.feedViewModel = feedViewModel
        status = feedViewModel.status
    }

    // MARK: - Public API

    func loadInitialIfNeeded(hasItems: Bool, modelContext: ModelContext) async {
        guard !didLoadInitial else { return }
        didLoadInitial = true

        if hasItems {
            status = .done
            persistLatestPostSnapshot(from: modelContext)
        }

        let shouldAutoRefresh: Bool = {
            if !hasItems { return true }
            guard let last = lastRefreshAt else { return true }
            return Date().timeIntervalSince(last) > staleInterval
        }()

        if shouldAutoRefresh {
            await refresh(modelContext: modelContext)
        }
    }

    func refresh(modelContext: ModelContext) async {
        guard !isRefreshing else { return }
        isRefreshing = true
        defer { isRefreshing = false }

        _ = try? await feedViewModel.getWatchFeed()
        status = feedViewModel.status
        lastRefreshAt = Date()

        persistLatestPostSnapshot(from: modelContext)

        WidgetCenter.shared.reloadTimelines(ofKind: "WidgetWatch")
    }

    func toggleFavorite(post: FeedDB, modelContext: ModelContext) {
        post.favorite.toggle()
        try? modelContext.save()
        showActions = true
    }

    // MARK: - Snapshot para Widget

    private func persistLatestPostSnapshot(from modelContext: ModelContext) {
        var descriptor = FetchDescriptor<FeedDB>(
            sortBy: [SortDescriptor(\.pubDate, order: .reverse)]
        )
        descriptor.fetchLimit = 1

        guard let last = try? modelContext.fetch(descriptor).first else { return }

        MacMagazineWidgetSharedStore.write(
            snapshot: .init(
                postId: last.postId,
                title: last.title,
                date: last.pubDate
            )
        )
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

    func setStatusForPreview(_ status: FeedViewModel.Status) {
        self.status = status
    }

    func openPost(withId postId: String, modelContext: ModelContext) {
        let predicate = #Predicate<FeedDB> { $0.postId == postId }
        let descriptor = FetchDescriptor<FeedDB>(predicate: predicate)

        if let post = try? modelContext.fetch(descriptor).first {
            selectedPostForDetail = SelectedPost(post: post)
        }
    }
}
