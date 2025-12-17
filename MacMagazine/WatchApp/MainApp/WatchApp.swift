import FeedLibrary
import StorageLibrary
import SwiftUI
import SwiftData

@main
struct WatchApp: App {

    private let database = Database(models: [FeedDB.self], inMemory: true)

    var body: some Scene {
        WindowGroup {
            FeedRootView(
                viewModel: FeedRootViewModel(
                    feedViewModel: FeedViewModel(
                        storage: database
                    )
                )
            )
            .modelContainer(database.sharedModelContainer)
        }
    }
}
