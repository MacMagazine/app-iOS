import MacMagazineLibrary
import OnboardingLibrary
import PodcastLibrary
import SearchLibrary
import SettingsLibrary
import StorageLibrary
import SwiftData
import SwiftUI

@main
struct MacMagazineApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var podcastPlayerManager = PodcastPlayerManager()
    @State var viewModel = MainViewModel()
    @State var shortcutManager = ShortcutManager.shared

    var body: some Scene {
        WindowGroup {
            content
            .onOpenURL { url in
                viewModel.deepLinkPostURL = url.absoluteString
            }
            .fullScreenCover(isPresented: Binding(
                get: { viewModel.deepLinkPostURL != nil },
                set: { if !$0 { viewModel.deepLinkPostURL = nil } }
            )) {
                if let url = viewModel.deepLinkPostURL {
                    DeepLinkNewsDetailView(url: url) {
                        viewModel.deepLinkPostURL = nil
                    }
                    .modelContainer(viewModel.storage.sharedModelContainer)
                    .environmentObject(viewModel.analytics)
                }
            }
            .sheet(
                item: $viewModel.onboardingCoordinator,
                content: { coordinator in
                    OnboardingContainerView(coordinator: coordinator)
                        .environment(\.theme, viewModel.theme)
                        .presentationDetents([.large])
                        .interactiveDismissDisabled(true)
                }
            )
            .onChange(of: shortcutManager.url) { _, value in
                if let value {
                    viewModel.deepLinkPostURL = value
                }
            }
            .task {
                shortcutManager.context = viewModel.storage.context
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
            .environment(viewModel.searchViewModel)
            .environment(podcastPlayerManager)
            .environment(\.removeAds, viewModel.settingsViewModel.removeAds)
            .environment(viewModel.sessionState)
            .environmentObject(viewModel.analytics)
            .preferredColorScheme(viewModel.settingsViewModel.colorSchema)
    }
}
