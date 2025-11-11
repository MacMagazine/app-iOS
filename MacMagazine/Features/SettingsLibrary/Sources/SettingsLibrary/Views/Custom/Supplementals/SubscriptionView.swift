import MacMagazineLibrary
import StoreKit
import SwiftUI
import UIComponentsLibrary
import UIKit

struct SubscriptionView: View {
    @Environment(\.openURL) var openURL
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @ObservedObject var viewModel = SubscriptionViewModel()

    @State private var selectedProduct: String?
    @State private var isPresentingPrivacy = false
    @State private var isPresentingTerms = false

    @State private var isPresentingLoginPatrao = false
    @State private var urlToOpen: URL?

    var body: some View {
        content
        .task {
            viewModel.storage = settingsViewModel.storage
            viewModel.get()
            try? await viewModel.getPurchasableProducts()
            viewModel.restore()
        }

        .onChange(of: viewModel.isPatrao) { _, value in
            Task { @MainActor in
                await viewModel.change(isPatrao: value)
            }
        }
    }
}

extension SubscriptionView {
    @ViewBuilder
    var content: some View {
        Section {
            if viewModel.isPatrao {
                logoffPatrao

            } else if viewModel.isValidSubscription {
                manageSubscription

            } else {
                purchaseOptions
                loginPatrao
            }
        } header: {
            headerContent
        } footer: {
            footer
        }
    }

    var headerContent: some View {
        HStack(alignment: .top) {
            Text("Remover Propagandas")
                .font(.headline)
        }
        .foregroundColor(theme.text.terciary.color)
    }
}

extension SubscriptionView {
    @ViewBuilder
    var purchaseOptions: some View {
        switch viewModel.status {
        case .idle:
            EmptyView()

        case .purchasable(let products):
            subscriptions(identifiers: products.compactMap(\.identifier))
            subscriptionOptions

        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, alignment: .center)

        case .error(let reason):
            ErrorView(message: reason)
            subscriptionOptions
        }
    }
}

// MARK: - SUBSCRIPTION -

extension SubscriptionView {
    @ViewBuilder
    private func subscriptions(identifiers: [String]) -> some View {
        ForEach(identifiers, id: \.self) { identifier in
            ProductView(id: identifier)
                .productViewStyle(.compact)
                .tint(theme.button.primary.color ?? .blue)
        }
    }

    @ViewBuilder
    private var subscriptionOptions: some View {
        restore
        manageSubscription
    }

    @ViewBuilder
    private var restore: some View {
        if case .purchasable(let products) = viewModel.status, !products.isEmpty {
            Button(action: {
                viewModel.restore()
            }, label: {
                Text("Recuperar").foregroundStyle(theme.main.tint.color ?? .blue)
            })
            .accessibilityLabel("Recupere assinaturas previamente feitas.")
        }
    }

    @ViewBuilder
    var manageSubscription: some View {
        if let url = URL(string: URLs.subscriptions),
           UIApplication.shared.canOpenURL(url) {
            Button(action: { openURL(url) },
                   label: {
                Text("Gerenciar").foregroundStyle(theme.main.tint.color ?? .blue)
            })
            .accessibilityLabel("Gerencia suas assinaturas do App.")
        }
    }
}

// MARK: - PATRAO -

extension SubscriptionView {
    @ViewBuilder
    var loginPatrao: some View {
        Button(action: {
#if os(iOS)
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
#endif
            isPresentingLoginPatrao.toggle()
        }, label: {
            Text("Sou patrão").foregroundStyle(theme.main.tint.color ?? .blue)
        })
        .accessibilityLabel("Fazer login como patrão para remover propagandas.")

        .sheet(isPresented: $isPresentingLoginPatrao) {
            let webviewController = WebviewController(isPresenting: $isPresentingLoginPatrao,
                                                      isPatrao: $viewModel.isPatrao,
                                                      openUrl: $urlToOpen)
            Webview(title: "Login para patrões",
                    url: URLs.login,
                    isPresenting: $isPresentingLoginPatrao,
                    navigationDelegate: webviewController,
                    userScripts: webviewController.userScripts)
        }

        if let url = urlToOpen {
            Divider().opacity(0)
                .task {
                    openURL(url) { _ in
                        urlToOpen = nil
                    }
                }
        }
    }

    @ViewBuilder
    var logoffPatrao: some View {
        Button(action: {
            #if os(iOS)
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            #endif
            viewModel.isPatrao = false
        }, label: {
            Text("Logoff de patrão").foregroundStyle(theme.main.tint.color ?? .blue)
        })
    }
}

// MARK: - FOOTER -

extension SubscriptionView {
    @ViewBuilder
    var footer: some View {
        HStack {
            Spacer()
            Button(action: { isPresentingTerms.toggle() },
                   label: {
                Text("Termos de Uso")
                    .plain(color: theme.text.terciary.color ?? .primary)
            })
            Spacer(minLength: 0)
            Button(action: { isPresentingPrivacy.toggle() },
                   label: {
                Text("Política de Privacidade")
                    .plain(color: theme.text.terciary.color ?? .primary)
            })
            Spacer()
        }

        .sheet(isPresented: $isPresentingTerms) {
            Webview(title: "Termos de Uso",
                    url: URLs.terms,
                    isPresenting: $isPresentingTerms)
        }

        .sheet(isPresented: $isPresentingPrivacy) {
            Webview(title: "Política de Privacidade",
                    url: URLs.privacy,
                    isPresenting: $isPresentingPrivacy)
        }
    }
}
