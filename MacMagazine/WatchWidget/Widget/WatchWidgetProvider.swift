import AppIntents
import FeedLibrary
import StorageLibrary
import SwiftUI
import WidgetKit

@MainActor
struct WatchWidgetProvider: AppIntentTimelineProvider {
    private let database = Database(models: [FeedDB.self], inMemory: false)

    func recommendations() -> [AppIntentRecommendation<AppIntent>] {
        [
            AppIntentRecommendation(
                intent: AppIntent(),
                description: "MacMagazine"
            )
        ]
    }

    func placeholder(in context: Context) -> WatchWidgetModel {
        WatchWidgetModel(
            date: .now,
            configuration: AppIntent(),
            postId: UUID().uuidString,
            postTitle: "Apple lança atualização do watchOS",
            postDate: .now.addingTimeInterval(-60 * 25)
        )
    }

    func snapshot(
        for configuration: AppIntent,
        in context: Context
    ) async -> WatchWidgetModel {
        await makeEntry(configuration: configuration)
    }

    func timeline(
        for configuration: AppIntent,
        in context: Context
    ) async -> Timeline<WatchWidgetModel> {
        let entry = await makeEntry(configuration: configuration)
        let nextUpdate = Date().addingTimeInterval(60 * 60)
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }

    private func makeEntry(configuration: AppIntent) async -> WatchWidgetModel {
        let viewModel = FeedViewModel(storage: database)
        let post = try? await viewModel.getWatchFeed(limit: 1).first

        return WatchWidgetModel(
            date: .now,
            configuration: configuration,
            postId: post?.postId,
            postTitle: post?.title ?? "MacMagazine",
            postDate: post?.pubDate
        )
    }
}
