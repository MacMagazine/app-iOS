import AnalyticsLibrary
import MacMagazineLibrary
import StoreKit
import SwiftUI
import UIComponentsLibrary
import UIKit

struct SubscriptionView: View {
    @EnvironmentObject private var analytics: AnalyticsManager
    @Environment(\.openURL) var openURL
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(SettingsViewModel.self) private var settingsViewModel
    @State var viewModel = SubscriptionViewModel()

    @State private var selectedProduct: String?

    @Binding var isPatrao: Bool
    @Binding var isPresentingLoginPatrao: Bool
    @Binding var urlToOpen: URL?

    var body: some View {
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
        }

        .task {
            viewModel.storage = settingsViewModel.storage
            await viewModel.get()
            if !viewModel.isPatrao {
                try? await viewModel.getPurchasableProducts()
                viewModel.restore()
            }
        }

        .onChange(of: viewModel.isPatrao) { _, value in
            Task { @MainActor in
                isPatrao = value
                await viewModel.change(isPatrao: value)
            }
        }
        .onChange(of: isPatrao) { _, value in
            if viewModel.isPatrao != value {
                viewModel.isPatrao = value
            }
        }
    }
}

extension SubscriptionView {
    var headerContent: some View {
        Text("Remover propagandas")
        .font(.headline)
        .foregroundColor(theme.text.terciary.color)
    }
}

extension SubscriptionView {
    @ViewBuilder
    var purchaseOptions: some View {
        switch viewModel.status {
        case .idle:
            EmptyView()

        case let .purchasable(products):
            subscriptions(identifiers: products.compactMap(\.identifier))
            subscriptionOptions

        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, alignment: .center)

        case let .error(reason):
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
                .productViewStyle(CustomProductViewStyle(theme: theme) {
                    viewModel.purchase(using: identifier, analytics: analytics)
                })
        }
    }

    @ViewBuilder
    private var subscriptionOptions: some View {
        // restore
        manageSubscription
    }

    @ViewBuilder
    private var restore: some View {
        if case let .purchasable(products) = viewModel.status, !products.isEmpty {
            Button(action: {
                viewModel.restore()
                analytics.track(.buttonTap(buttonId: AnalyticsConstants.ButtonID.restorePurchase.id, screen: AnalyticsConstants.Screen.settings.name))
            }, label: {
                Text("Recuperar compra").foregroundStyle(theme.main.tint.color ?? .blue)
            })
            .accessibilityLabel("Recupere assinaturas previamente feitas.")
        }
    }

    @ViewBuilder
    var manageSubscription: some View {
        if let url = URL(string: URLs.subscriptions),
           UIApplication.shared.canOpenURL(url) {
            Button(action: {
                openURL(url)
                analytics.track(.buttonTap(buttonId: AnalyticsConstants.ButtonID.manageSubscription.id, screen: AnalyticsConstants.Screen.settings.name))
            },
                   label: {
                Text("Gerenciar assinatura").foregroundStyle(theme.main.tint.color ?? .blue)
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
            analytics.track(.buttonTap(buttonId: AnalyticsConstants.ButtonID.loginPatrao.id, screen: AnalyticsConstants.Screen.settings.name))
        }, label: {
            Text("Sou patrão via Patreon/Catarse").foregroundStyle(theme.main.tint.color ?? .blue)
        })
        .accessibilityLabel("Fazer login como patrão para remover propagandas.")

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
            analytics.track(.buttonTap(buttonId: AnalyticsConstants.ButtonID.logoffPatrao.id, screen: AnalyticsConstants.Screen.settings.name))
        }, label: {
            Text("Logout de patrão").foregroundStyle(theme.main.tint.color ?? .blue)
        })
    }
}
