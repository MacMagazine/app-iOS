import AnalyticsLibrary
import MacMagazineLibrary
import MacMagazineUILibrary
import SwiftUI

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
                NavigationStack {
                    SimpleWebView(url: presentingContent.url)
                        .navigationTitle(presentingContent.title)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button(action: { presentingContent = .none },
                                       label: { Text("Fechar") })
                                .buttonStyle(.plain)
                                .tint(.primary)
                                .glassEffect(.regular.interactive(), in: .capsule)
                            }
                        }
                }
                .trackScreen(
                    presentingContent.title,
                    previous: nil,
                    analytics: analytics
                )
            }

            .sheet(isPresented: $isPresentingLoginPatrao) {
                NavigationStack {
                    SimpleWebView(
                        url: URLs.login,
                        userScripts: [MMWebViewUserScripts.removeBackToBlog],
                        onNavigationCommitted: { url in
                            if url.absoluteString.hasPrefix(URLs.success) {
                                isPatrao = true
                                isPresentingLoginPatrao = false
                            }
                        }
                    )
                    .navigationTitle("Login para patrões")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button(action: { isPresentingLoginPatrao = false },
                                   label: { Text("Fechar") })
                            .buttonStyle(.plain)
                            .tint(.primary)
                            .glassEffect(.regular.interactive(), in: .capsule)
                        }
                    }
                }
                .trackScreen(
                    "Login para patrões",
                    previous: nil,
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
                CustomNewsView()
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
