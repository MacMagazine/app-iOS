import OnboardingLibrary
import PodcastLibrary
import SettingsLibrary
import StorageLibrary
import SwiftData
import SwiftUI

@main
struct MacMagazineApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var podcastPlayerManager = PodcastPlayerManager()
    @State var viewModel = MainViewModel()

    var body: some Scene {
        WindowGroup {
            content
            .sheet(
                item: $viewModel.onboardingCoordinator,
                content: { coordinator in
                    OnboardingContainerView(coordinator: coordinator)
                        .environment(\.theme, viewModel.theme)
                        .presentationDetents([.large])
                        .interactiveDismissDisabled(true)
                }
            )
            .task {
                podcastPlayerManager.observeSessionState(viewModel.sessionState)
                await viewModel.initializeOnboarding()
            }
        }
        .environment(\.theme, viewModel.theme)
    }
}

private extension MacMagazineApp {
    var content: some View {
        MainView()
            .modelContainer(viewModel.storage.sharedModelContainer)
            .environment(viewModel)
            .environment(viewModel.settingsViewModel)
            .environment(podcastPlayerManager)
            .environment(\.removeAds, viewModel.settingsViewModel.removeAds)
            .environmentObject(viewModel.sessionState)
            .environmentObject(viewModel.analytics)
            .preferredColorScheme(viewModel.settingsViewModel.colorSchema)
    }
}
