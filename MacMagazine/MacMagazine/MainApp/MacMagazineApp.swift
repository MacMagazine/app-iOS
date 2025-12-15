import FirebaseCore
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

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {}

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {}
}
