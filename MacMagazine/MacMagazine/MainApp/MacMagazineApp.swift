import PodcastLibrary
import SettingsLibrary
import StorageLibrary
import SwiftData
import SwiftUI
import UIKit

@main
struct MacMagazineApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var podcastPlayerManager = PodcastPlayerManager()
    @State var viewModel = MainViewModel()

    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(viewModel.storage.sharedModelContainer)
                .environment(viewModel)
                .environment(viewModel.settingsViewModel)
                .environment(podcastPlayerManager)
                .environment(\.removeAds, viewModel.settingsViewModel.removeAds)
                .environmentObject(viewModel.sessionState)
                .environmentObject(viewModel.analytics)
                .preferredColorScheme(viewModel.settingsViewModel.colorSchema)
                .task {
                    podcastPlayerManager.observeSessionState(viewModel.sessionState)
                    UIApplication.shared.registerForRemoteNotifications()
                }
        }
        .environment(\.theme, viewModel.theme)
    }
}
