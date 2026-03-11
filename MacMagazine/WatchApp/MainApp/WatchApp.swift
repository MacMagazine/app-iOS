import FeedLibrary
import StorageLibrary
import SwiftData
import SwiftUI
import WatchKit

@main
struct WatchApp: App {

    private let database: Database
    @State private var viewModel: FeedMainViewModel

    @WKApplicationDelegateAdaptor(WatchNotificationsDelegate.self)
    private var pushDelegate

    init() {
        let database = Database(models: [FeedDB.self], inMemory: false)
        self.database = database
        _viewModel = State(wrappedValue: FeedMainViewModel(
            feedViewModel: FeedViewModel(storage: database)
        ))
    }

    var body: some Scene {
        WindowGroup {
            FeedMainView(viewModel: viewModel)
                .modelContainer(database.sharedModelContainer)
                .onAppear {
                    pushDelegate.viewModel = viewModel
                }
        }
    }
}
