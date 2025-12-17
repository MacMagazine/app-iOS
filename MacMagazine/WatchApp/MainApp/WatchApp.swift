import FeedLibrary
import StorageLibrary
import SwiftData
import SwiftUI

@main
struct WatchApp: App {

    private let database = Database(models: [FeedDB.self], inMemory: true)

    var body: some Scene {
        WindowGroup {
            FeedRootView(
                viewModel: FeedRootViewModel(
                    feedViewModel: FeedViewModel(
                        network: nil,
                        storage: database
                    )
                )
            )
            .modelContainer(database.sharedModelContainer)
        }
    }
}
