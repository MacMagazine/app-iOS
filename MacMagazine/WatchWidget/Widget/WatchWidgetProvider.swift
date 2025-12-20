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
            lastPostId: UUID().uuidString,
            lastPostTitle: "Apple lança atualização do watchOS",
            lastPostDate: .now.addingTimeInterval(-60 * 25)
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

        let nextUpdate = Date().addingTimeInterval(5 * 60)
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }

    private func makeEntry(configuration: AppIntent) -> WatchWidgetModel {
        let snap = MacMagazineWidgetSharedStore.readPost()

        return WatchWidgetModel(
            date: .now,
            configuration: configuration,
            lastPostId: snap?.id,
            lastPostTitle: snap?.title ?? "MacMagazine",
            lastPostDate: snap?.date
        )
    }
}
