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

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        configureFirebaseIfAvailable()
        return true
    }

    private func configureFirebaseIfAvailable() {
        // Check if GoogleService-Info.plist exists in the bundle
        guard let plistPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              FileManager.default.fileExists(atPath: plistPath) else {
            return
        }

        // Verify it's not the template file by checking for placeholder values
        if let plistDict = NSDictionary(contentsOfFile: plistPath),
           let apiKey = plistDict["API_KEY"] as? String,
           apiKey.contains("YOUR_API_KEY_HERE") {
            return
        }

        FirebaseApp.configure()
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {}

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {}
}
