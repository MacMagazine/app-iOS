import FeedLibrary
import StorageLibrary
import SwiftUI
import WidgetKit

@MainActor
struct MacMagazineTimelineProvider: TimelineProvider {
    let viewModel = FeedViewModel(
        storage: Database(models: [], inMemory: true)
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
            var posts = [WidgetData]()

            let fetchedData = try await viewModel.getWidgetData()
            for data in fetchedData {
                var imageData: Data?
                do {
                    if let thumbnailUrl = URL(string: data.thumbnail) {
                        let request = URLRequest(url: thumbnailUrl)
                        let (image, _) = try await URLSession.shared.data(for: request)
                        imageData = image
                    }
                } catch {}
                posts.append(WidgetData(
                    postId: data.postId,
                    title: data.title,
                    thumbnail: data.thumbnail,
                    pubDate: data.pubDate,
                    link: data.link,
                    imageData: imageData
                ))
            }
            return posts
        } catch {
            return []
        }
    }
}
