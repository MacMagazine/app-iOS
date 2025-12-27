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

    @State private var isBackgroundDimming = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                content
                overlay
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
            .blur(radius: isBackgroundDimming ? 18 : 0)
            .animation(.easeInOut(duration: 0.45), value: isBackgroundDimming)
    }

    var overlay: some View {
        Rectangle()
            .fill(.regularMaterial)
            .overlay { Color.black.opacity(0.18) }
            .ignoresSafeArea()
            .opacity(isBackgroundDimming ? 1 : 0)
            .animation(.easeInOut(duration: 0.35), value: isBackgroundDimming)
            .allowsHitTesting(false)
    }
}
