import StorageLibrary
import SwiftData
import SwiftUI

@main
struct MacMagazineApp: App {
    @ObservedObject var viewModel = MainViewModel()

    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(viewModel.storage.sharedModelContainer)
                .environmentObject(viewModel)
                .environmentObject(viewModel.settingsViewModel)
                .preferredColorScheme(viewModel.colorSchema)
        }
        .environment(\.theme, viewModel.theme)
    }
}
