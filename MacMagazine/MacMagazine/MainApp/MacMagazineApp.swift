import SettingsLibrary
import StorageLibrary
import SwiftData
import SwiftUI
import UIKit

@main
struct MacMagazineApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var viewModel = MainViewModel()

    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(viewModel.storage.sharedModelContainer)
                .environment(viewModel)
                .environment(viewModel.settingsViewModel)
                .preferredColorScheme(viewModel.settingsViewModel.colorSchema)
                .task {
                    UIApplication.shared.registerForRemoteNotifications()
                }
        }
        .environment(\.theme, viewModel.theme)
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {}

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {}
}
