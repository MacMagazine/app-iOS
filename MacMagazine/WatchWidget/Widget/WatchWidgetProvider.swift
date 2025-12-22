import FeedLibrary
import StorageLibrary
import SwiftUI
import WidgetKit

@MainActor
struct WatchWidgetProvider: TimelineProvider {
    private let database = Database(models: [FeedDB.self], inMemory: true)

    func placeholder(in context: Context) -> WatchWidgetModel {
        WatchWidgetModel(
            date: .now,
            postId: UUID().uuidString,
            postTitle: "Apple lança atualização do watchOS",
            postDate: .now.addingTimeInterval(-60 * 25)
        )
    }

    func getSnapshot(in context: Context, completion: @escaping @Sendable (WatchWidgetModel) -> Void) {
        Task {
            let entry = await makeEntry(for: .now)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<WatchWidgetModel>) -> Void) {
        Task {
            let entry = await makeEntry(for: .now)
            guard let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) else {
                completion(Timeline(entries: [entry], policy: .atEnd))
                return
            }
            completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
        }
    }
}

private extension WatchWidgetProvider {
    func makeEntry(for date: Date) async -> WatchWidgetModel {
        let viewModel = FeedViewModel(storage: database)
        let post = try? await viewModel.getWatchFeed(limit: 1).first

        return WatchWidgetModel(
            date: date,
            postId: post?.postId,
            postTitle: post?.title ?? "MacMagazine",
            postDate: post?.pubDate
        )
    }
}
