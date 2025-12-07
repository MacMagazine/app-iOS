import StorageLibrary
import SwiftData
import SwiftUI

@main
struct MacMagazineApp: App {
    @State var viewModel = MainViewModel()

    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(viewModel.storage.sharedModelContainer)
                .environment(viewModel)
                .environment(viewModel.settingsViewModel)
                .preferredColorScheme(viewModel.colorSchema)
        }
        .environment(\.theme, viewModel.theme)
    }
}
