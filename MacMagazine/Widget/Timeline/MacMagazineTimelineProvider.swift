import FeedLibrary
import Kingfisher
import StorageLibrary
import SwiftUI
import WidgetKit

@MainActor
struct MacMagazineTimelineProvider: TimelineProvider {
    let viewModel = FeedViewModel(
        storage: Database(models: [WidgetDataDB.self], inMemory: true)
    )

    func placeholder(in context: Context) -> RecentPostsEntry {
        RecentPostsEntry(date: Date(), posts: [.placeholder, .placeholder, .placeholder])
    }

    func getSnapshot(in context: Context, completion: @escaping (RecentPostsEntry) -> Void) {
        Task {
            let posts = await getWidgetContent()
            completion(RecentPostsEntry(date: Date(), posts: posts))
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<RecentPostsEntry>) -> Void) {
        Task {
            let posts = await getWidgetContent()
            let timeline = Timeline(entries: [RecentPostsEntry(date: Date(), posts: posts)], policy: .atEnd)
            completion(timeline)
        }
    }
}

private extension MacMagazineTimelineProvider {
    func getWidgetContent() async -> [WidgetData] {
        do {
            let posts = try await viewModel.getWidgetData()
            let urls = posts.compactMap { $0.thumbnail }.compactMap { URL(string: $0) }
            ImagePrefetcher(urls: urls, completionHandler: { _, _, _ in }).start()
            return posts
        } catch {
            return []
        }
    }
}
