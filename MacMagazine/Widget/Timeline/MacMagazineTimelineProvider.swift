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

    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date(), posts: [.placeholder, .placeholder, .placeholder])
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> Void) {
        Task {
            let posts = await getWidgetContent()
            completion(WidgetEntry(date: Date(), posts: posts))
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> Void) {
        Task {
            let posts = await getWidgetContent()
            let timeline = Timeline(entries: [WidgetEntry(date: Date(), posts: posts)], policy: .atEnd)
            completion(timeline)
        }
    }
}

private extension MacMagazineTimelineProvider {
    func getWidgetContent() async -> [WidgetData] {
        do {
            let posts = try await viewModel.getWidgetData()
            let urls = posts.compactMap { $0.thumbnail }.compactMap { URL(string: $0) }
            for url in urls {
                _ = try? await ImageDownloader.default.downloadImage(with: url)
            }
            return posts
        } catch {
            return []
        }
    }
}
