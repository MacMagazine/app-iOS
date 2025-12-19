import FeedLibrary
import StorageLibrary
import SwiftData
import SwiftUI
import UserNotifications
import WatchKit

@main
struct WatchApp: App {

    private let database = Database(models: [FeedDB.self], inMemory: false)

    @WKApplicationDelegateAdaptor(WatchNotificationsDelegate.self)
    private var notifDelegate

    var body: some Scene {
        WindowGroup {
            FeedMainView(
                viewModel: FeedMainViewModel(
                    feedViewModel: FeedViewModel(storage: database)
                )
            )
            .modelContainer(database.sharedModelContainer)
            .onOpenURL { url in
                handleDeepLink(url)
            }
        }
    }

    @MainActor
    private func handleDeepLink(_ url: URL) {
        guard url.scheme == "macmagazine" else { return }

        let host = url.host ?? ""
        let pathComponents = url.pathComponents.filter { $0 != "/" }

        guard host == "news" else { return }

        if pathComponents.count >= 2, pathComponents[0] == "post" {
            _ = pathComponents[1]
        }
    }
}
