import AppIntents
import SwiftUI
import WidgetKit

struct WatchWidgetProvider: AppIntentTimelineProvider {

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
        makeEntry(configuration: configuration)
    }

    func timeline(
        for configuration: AppIntent,
        in context: Context
    ) async -> Timeline<WatchWidgetModel> {
        let entry = makeEntry(configuration: configuration)
        let nextUpdate = Date().addingTimeInterval(60 * 60)
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }

    private func makeEntry(configuration: AppIntent) -> WatchWidgetModel {
        let snap = MacMagazineWidgetSharedStore.readPost()

        return WatchWidgetModel(
            date: .now,
            configuration: configuration,
            postId: snap?.id,
            postTitle: snap?.title ?? "MacMagazine",
            postDate: snap?.date
        )
    }
}
