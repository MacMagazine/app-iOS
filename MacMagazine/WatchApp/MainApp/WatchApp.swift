import FeedLibrary
import StorageLibrary
import SwiftData
import SwiftUI

@main
struct WatchApp: App {

    private let database = Database(models: [FeedDB.self], inMemory: false)

    var body: some Scene {
        WindowGroup {
            FeedMainView(
                viewModel: FeedMainViewModel(
                    feedViewModel: FeedViewModel(storage: database)
                )
            )
            .modelContainer(database.sharedModelContainer)
        }
    }
}
