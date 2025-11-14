import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

public struct SettingsView: View {
    @Environment(\.theme) var theme: ThemeColor

    @State private var presentingContent = AboutViewModel.ButtonAction.none

    @State var isPatrao = false
    @State var urlToOpen: URL?
    @State private var isPresentingLoginPatrao = false

    public init() {}

    public var body: some View {
        NavigationStack {
            List {

                SubscriptionView(
                    isPatrao: $isPatrao,
                    isPresentingLoginPatrao: $isPresentingLoginPatrao,
                    urlToOpen: $urlToOpen
                )

                PostsVisibilityView()
                AppearanceView()
                IconsView()
                AboutView(presentingContent: $presentingContent)
            }
            .navigationTitle("Ajustes")
        }

        .sheet(isPresented: Binding(get: { presentingContent != .none },
                                    set: { _ in presentingContent = .none })) {
            Webview(title: presentingContent.title,
                    url: presentingContent.url,
                    isPresenting: Binding(get: { presentingContent != .none },
                                          set: { _ in presentingContent = .none }))
        }

        .sheet(isPresented: $isPresentingLoginPatrao) {
            let webviewController = WebviewController(isPresenting: $isPresentingLoginPatrao,
                                                      isPatrao: $isPatrao,
                                                      openUrl: $urlToOpen)
            Webview(title: "Login para patrões",
                    url: URLs.login,
                    isPresenting: $isPresentingLoginPatrao,
                    navigationDelegate: webviewController,
                    userScripts: webviewController.userScripts)
        }
    }
}

#if DEBUG
import StorageLibrary

#Preview {
    let storage = Database(models: [SettingsDB.self], inMemory: true)

    SettingsView()
    .environment(\.theme, ThemeColor())
    .environmentObject(SettingsViewModel(storage: storage))
}
#endif

