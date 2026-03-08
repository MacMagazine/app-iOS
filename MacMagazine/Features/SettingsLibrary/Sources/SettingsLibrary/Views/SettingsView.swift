import AnalyticsLibrary
import MacMagazineLibrary
import MacMagazineUILibrary
import SwiftUI
@preconcurrency import WebKit

public struct SettingsView: View {
    @EnvironmentObject private var analytics: AnalyticsManager
    @Environment(\.theme) var theme: ThemeColor

    @State private var presentingContent = AboutViewModel.ButtonAction.none
    @State private var isPresentingLoginPatrao = false
    @State private var editMode = EditMode.active
    @State var isPatrao = false
    @State var urlToOpen: URL?

    public init() {}

    public var body: some View {
        settingsContent
            .sheet(isPresented: Binding(get: { presentingContent != .none },
                                        set: { _ in presentingContent = .none })) {
                ContentSheet(
                    url: presentingContent.url,
                    title: presentingContent.title,
                    onDismiss: { presentingContent = .none },
                    analytics: analytics
                )
            }

            .sheet(isPresented: $isPresentingLoginPatrao) {
                PatronLoginSheet(
                    onLoginSuccess: {
                        isPatrao = true
                        isPresentingLoginPatrao = false
                    },
                    onDismiss: { isPresentingLoginPatrao = false },
                    analytics: analytics
                )
            }
    }
}

private extension SettingsView {
    var settingsContent: some View {
        ZStack {
            (theme.main.background.color ?? Color.secondary).ignoresSafeArea()
            List {
                PostsVisibilityView()
                appearance
                SubscriptionView(
                    isPatrao: $isPatrao,
                    isPresentingLoginPatrao: $isPresentingLoginPatrao,
                    urlToOpen: $urlToOpen
                )
                AboutView(presentingContent: $presentingContent)
            }
            .navigationTitle(AppTabs.settings.rawValue)
        }
        .contentMargins(.top, 20, for: .scrollContent)
        .trackScreen(
            "Ajustes",
            previous: nil,
            analytics: analytics
        )
    }

    var appearance: some View {
        NavigationLink {
            List {
                AppearanceView()
                IconsView()
                CustomTabView()
                // CustomNewsView()
                CustomSocialView()
            }
            .navigationTitle("Aparência")
            .navigationBarTitleDisplayMode(.inline)
            .environment(\.editMode, $editMode)
            .trackScreen(
                "Ajustes > Aparência",
                previous: nil,
                analytics: analytics
            )

        } label: {
            Label("Aparência", systemImage: "highlighter.badge.ellipsis")
        }
    }
}

// MARK: - Content Sheet (Terms / Privacy)

private struct ContentSheet: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var page: WebPage?

    let url: String
    let title: String
    let onDismiss: () -> Void
    let analytics: AnalyticsManager

    var body: some View {
        NavigationStack {
            ManagedWebView(
                style: .init(ignoredSafeAreaEdges: .bottom),
                pageProvider: {
                    let configuration = WebPage.Configuration()
                    configuration.userContentController.addUserScript(
                        MMWebViewUserScripts.hideSiteHeader
                    )
                    return WebPage(configuration: configuration)
                },
                loadAction: { page in
                    guard let requestURL = URL(string: url) else { return }
                    for try await event in page.load(URLRequest(url: requestURL)) {
                        if case .finished = event { return }
                    }
                },
                page: $page
            )
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: onDismiss,
                           label: { Image(systemName: "xmark") })
                    .tint(.primary)
                }
            }
            .onChange(of: colorScheme) {
                page?.reload()
            }
        }
        .trackScreen(title, previous: nil, analytics: analytics)
    }
}

// MARK: - Patron Login Sheet

private struct PatronLoginSheet: View {
    @State private var page: WebPage?

    let onLoginSuccess: () -> Void
    let onDismiss: () -> Void
    let analytics: AnalyticsManager

    var body: some View {
        NavigationStack {
            ManagedWebView(
                style: .init(ignoredSafeAreaEdges: .bottom),
                pageProvider: { makeLoginPage() },
                loadAction: { page in
                    guard let requestURL = URL(string: URLs.login) else { return }
                    for try await event in page.load(URLRequest(url: requestURL)) {
                        if case .finished = event { return }
                    }
                },
                postLoadAction: { page in
                    do {
                        for try await event in page.navigations {
                            if case .committed = event, let url = page.url {
                                if url.absoluteString.hasPrefix(URLs.success) {
                                    onLoginSuccess()
                                }
                            }
                        }
                    } catch {
                    }
                },
                page: $page
            )
            .navigationTitle("Login para patrões")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: onDismiss,
                           label: { Image(systemName: "xmark") })
                    .tint(.primary)
                }
            }
        }
        .trackScreen("Login para patrões", previous: nil, analytics: analytics)
    }

    private func makeLoginPage() -> WebPage {
        let configuration = WebPage.Configuration()
        configuration.userContentController.addUserScript(
            MMWebViewUserScripts.removeBackToBlog
        )
        return WebPage(configuration: configuration)
    }
}

#if DEBUG
import StorageLibrary

#Preview {
    let storage = Database(models: [SettingsDB.self], inMemory: true)

    NavigationStack {
        SettingsView()
    }
        .environment(\.theme, ThemeColor())
        .environment(SettingsViewModel(storage: storage, models: []))
}
#endif
