import FeedLibrary
import StorageLibrary
import SwiftUI
import WidgetKit

@MainActor
struct WatchWidgetProvider: TimelineProvider {
    private let database = Database(models: [], inMemory: true)

    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date(), post: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping @Sendable (WidgetEntry) -> Void) {
        Task {
            if let post = await getWidgetContent() {
                completion(WidgetEntry(date: Date(), post: post))
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<WidgetEntry>) -> Void) {
        Task {
            if let post = await getWidgetContent(for: Date()) {
                guard let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) else {
                    let timeline = Timeline(entries: [WidgetEntry(date: Date(), post: post)], policy: .atEnd)
                    completion(timeline)
                    return
                }
                let timeline = Timeline(entries: [WidgetEntry(date: Date(), post: post)], policy: .after(nextUpdate))
                completion(timeline)
            }
        }
    }
}

private extension WatchWidgetProvider {
    func getWidgetContent(for date: Date = Date()) async -> WidgetData? {
        let viewModel = FeedViewModel(storage: database)
        return try? await viewModel.getWidgetData(limit: 1).first
    }
}
