import FirebaseCore
import OnboardingLibrary
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

    @State private var didResolveOnboarding = false
    @State private var isBackgroundDimming = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                MainView()
                    .modelContainer(viewModel.storage.sharedModelContainer)
                    .environment(viewModel)
                    .environment(viewModel.settingsViewModel)
                    .environment(podcastPlayerManager)
                    .environment(\.removeAds, viewModel.settingsViewModel.removeAds)
                    .environmentObject(viewModel.sessionState)
                    .environmentObject(viewModel.analytics)
                    .preferredColorScheme(viewModel.settingsViewModel.colorSchema)
                    .blur(radius: isBackgroundDimming ? 18 : 0)
                    .animation(.easeInOut(duration: 0.45), value: isBackgroundDimming)

                Rectangle()
                    .fill(.regularMaterial)
                    .overlay { Color.black.opacity(0.18) }
                    .ignoresSafeArea()
                    .opacity(isBackgroundDimming ? 1 : 0)
                    .animation(.easeInOut(duration: 0.35), value: isBackgroundDimming)
                    .allowsHitTesting(false)
            }
            .animation(.easeInOut(duration: 0.45), value: isBackgroundDimming)
            .sheet(
                item: $viewModel.onboardingCoordinator,
                onDismiss: {
                    Task { @MainActor in
                        try? await Task.sleep(nanoseconds: 20_000_000)
                        withAnimation(.easeInOut(duration: 0.45)) {
                            isBackgroundDimming = false
                        }
                    }
                },
                content: { coordinator in
                    OnboardingContainerView(coordinator: coordinator)
                        .environment(\.theme, viewModel.theme)
                        .presentationDetents([.large])
                        .interactiveDismissDisabled(true)
                }
            )
            .task {
                podcastPlayerManager.observeSessionState(viewModel.sessionState)

                isBackgroundDimming = true

                await viewModel.initializeOnboarding()

                if viewModel.onboardingCoordinator == nil {
                    withAnimation(.easeInOut(duration: 0.45)) {
                        isBackgroundDimming = false
                    }
                }
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
