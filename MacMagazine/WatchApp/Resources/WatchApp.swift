import FeedLibrary
import StorageLibrary
import SwiftUI

@main
struct WatchApp: App {

    private let database = Database(models: [FeedDB.self], inMemory: false)

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
        }
    }
}
