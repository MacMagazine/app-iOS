import MacMagazineLibrary
import StoreKit
import SwiftUI
import UIComponentsLibrary
import UIKit

struct SubscriptionView: View {
    @Environment(\.openURL) var openURL
    @Environment(\.theme) var theme: ThemeColor
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @ObservedObject var viewModel = SubscriptionViewModel()

    @State private var selectedProduct: String?
    @State private var isPresentingPrivacy = false
    @State private var isPresentingTerms = false

    @State private var isPresentingLoginPatrao = false
    @State private var urlToOpen: URL?

    let type: SettingsViewType

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
        switch type {
        case .custom: customView
        case .native: nativeView
        }
    }

    var customView: some View {
        VStack(alignment: .leading) {
            headerContent(icon: true)

            if viewModel.isPatrao {
                logoffPatrao

            } else if viewModel.isValidSubscription {
                manageSubscription

            } else {
                purchaseOptions
                loginPatrao
            }

            footer
        }
    }

    func headerContent(icon: Bool) -> some View {
        HStack(alignment: .top) {
            if icon {
                Image(systemName: "menubar.dock.rectangle.badge.record")
                    .font(.system(size: 20))
                    .foregroundColor(theme.button.primary.color ?? .blue)
            }

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
            switch type {
            case .custom:
                subscriptionOptions.padding(.top)

            case .native:
                subscriptionOptions
            }

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
        switch type {
        case .custom:
            HStack {
                restore
                manageSubscription
            }

        case .native:
            restore
            manageSubscription
        }
    }

    @ViewBuilder
    private var restore: some View {
        if case .purchasable(let products) = viewModel.status, !products.isEmpty {
            Button(action: {
                viewModel.restore()
            }, label: {
                switch type {
                case .custom:
                    Text("Recuperar".uppercased())
                        .borderedFullSize(color: theme.button.primary.color ?? .blue,
                                          stroke: theme.button.primary.color ?? .blue)

                case .native:
                    Text("Recuperar").foregroundStyle(theme.main.tint.color ?? .blue)
                }
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
                switch type {
                case .custom:
                    Text("Gerenciar".uppercased())
                        .borderedFullSize(color: theme.button.primary.color ?? .blue,
                                          stroke: theme.button.primary.color ?? .blue)

                case .native:
                    Text("Gerenciar").foregroundStyle(theme.main.tint.color ?? .blue)
                }
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
            switch type {
            case .custom:
                Text("Sou patrão".uppercased())
                    .roundedFullSize(fill: theme.button.primary.color ?? .blue)

            case .native:
                Text("Sou patrão").foregroundStyle(theme.main.tint.color ?? .blue)
            }
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
            switch type {
            case .custom:
                Text("Logoff de patrão".uppercased())
                    .roundedFullSize(fill: theme.button.primary.color ?? .blue)

            case .native:
                Text("Logoff de patrão").foregroundStyle(theme.main.tint.color ?? .blue)
            }
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
