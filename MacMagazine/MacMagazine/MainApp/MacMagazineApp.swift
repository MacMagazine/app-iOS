import AnalyticsLibrary
import LoggerLibrary
import MacMagazineLibrary
import OnboardingLibrary
import PodcastLibrary
import SearchLibrary
import SettingsLibrary
import StorageLibrary
import SwiftData
import SwiftUI
import UserNotifications

@main
struct MacMagazineApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            SceneView()
        }
    }
}

struct SceneView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var podcastPlayerManager = PodcastPlayerManager()
    @State var shortcutManager = ShortcutManager.shared
    @Bindable var viewModel: MainViewModel

    init(viewModel: MainViewModel? = nil) {
        if let viewModel {
            self.viewModel = viewModel
        } else {
            let pushNotification = PushNotification()
            pushNotification.initialize(options: PushNotificationDefinition.options)

            self.viewModel = MainViewModel(pushNotification: pushNotification)
        }
    }

    var body: some View {
        content
            .onOpenURL { url in
                viewModel.deepLinkPostURL = url.absoluteString
                viewModel.analytics.track(.buttonTap(
                    buttonId: AnalyticsConstants.ButtonID.deepLinkOpened("widget").id,
                    screen: AnalyticsConstants.Screen.deepLinkDetail.name
                ))
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
            .onChange(of: viewModel.pushNotification.newContentAvailable) { _, url in
                if let url {
                    viewModel.deepLinkPostURL = url
                    viewModel.pushNotification.newContentAvailable = nil
                    viewModel.analytics.track(.buttonTap(
                        buttonId: AnalyticsConstants.ButtonID.deepLinkOpened("push").id,
                        screen: AnalyticsConstants.Screen.deepLinkDetail.name
                    ))
                }
            }
            .onChange(of: shortcutManager.url) { _, value in
                if let value {
                    viewModel.deepLinkPostURL = value
                    viewModel.analytics.track(.buttonTap(
                        buttonId: AnalyticsConstants.ButtonID.deepLinkOpened("shortcut").id,
                        screen: AnalyticsConstants.Screen.deepLinkDetail.name
                    ))
                }
            }
            .onChange(of: shortcutManager.tab) { _, value in
                if let value {
                    viewModel.tab = value
                }
            }
            .onChange(of: scenePhase) { _, phase in
                if phase == .active {
                    UNUserNotificationCenter.current().setBadgeCount(0)
                }
            }
            .task {
                viewModel.logger?.debug(viewModel.pushNotification.newContentAvailable ?? "No newContentAvailable")
                if let url = viewModel.pushNotification.newContentAvailable {
                    viewModel.pushNotification.newContentAvailable = nil
                    viewModel.deepLinkPostURL = url
                    viewModel.analytics.track(.buttonTap(
                        buttonId: AnalyticsConstants.ButtonID.deepLinkOpened("push").id,
                        screen: AnalyticsConstants.Screen.deepLinkDetail.name
                    ))
                }
                shortcutManager.context = viewModel.storage.sharedModelContainer.mainContext
                podcastPlayerManager.observeSessionState(viewModel.sessionState)
                viewModel.analytics.track(.app(.open))
                viewModel.analytics.track(.buttonTap(
                    buttonId: AnalyticsConstants.ButtonID.appLaunched.id,
                    screen: AnalyticsConstants.Screen.news.name
                ))
                await viewModel.initializeOnboarding()
            }
            .environment(\.theme, viewModel.theme)
    }
}

private extension SceneView {
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
