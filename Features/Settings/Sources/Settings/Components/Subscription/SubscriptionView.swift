import CommonLibrary
import SwiftUI
import UIComponentsLibrary
import UIComponentsLibrarySpecial

public struct SubscriptionView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var viewModel: SettingsViewModel
    @State private var selectedProduct: String?

    public init() {}

    public var body: some View {
        VStack(spacing: 10) {
            Section(content: {
                Group {
                    if viewModel.isPatrao {
                        Button(action: { viewModel.isPatrao = false },
                               label: {
                            Text("Logoff de patrão".uppercased())
                                .roundedFullSize(fill: theme.button.primary.color ?? .blue)
                        })
                        .padding(.top)

                    } else if viewModel.subscriptionValid {
                        manageSubscription
                            .padding(.top)

                    } else {
                        switch viewModel.status {
                        case .done:
                            sectionSubscription
                            subscribe
                            subscriptionOptions

                        case .purchasable(let products):
                            sectionSubscription(products.count)
                            subscriptionOptions

                        case .loading:
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }

                        case .error(let reason):
                            Group {
                                ErrorView(message: reason)
                                subscriptionOptions
                            }
                            .padding(.top)
                        }

                        sectionPatrao
                    }
                }

            }, footer: {
                HStack {
                    Spacer()
                    Button(action: { viewModel.isPresentingTerms.toggle() },
                           label: {
                        Text("Termos de Uso")
                            .plain(color: theme.text.terciary.color ?? .primary)
                    })
                    Spacer(minLength: 0)
                    Button(action: { viewModel.isPresentingPrivacy.toggle() },
                           label: {
                        Text("Política de Privacidade")
                            .plain(color: theme.text.terciary.color ?? .primary)
                    })
                    Spacer()
                }
            })
        }

        .sheet(isPresented: $viewModel.isPresentingLoginPatrao) {
            Webview(title: "Login para patrões",
                    url: APIParams.patraoLoginUrl,
                    isPresenting: $viewModel.isPresentingLoginPatrao,
                    navigationDelegate: WebviewController(isPresenting: $viewModel.isPresentingLoginPatrao,
                                                          isPatrao: $viewModel.isPatrao),
                    userScripts: WebviewController().userScripts)
        }

        .sheet(isPresented: $viewModel.isPresentingTerms) {
            Webview(title: "Termos de Uso",
                    url: APIParams.termsUrl,
                    isPresenting: $viewModel.isPresentingTerms)
        }

        .sheet(isPresented: $viewModel.isPresentingPrivacy) {
            Webview(title: "Política de Privacidade",
                    url: APIParams.privacyUrl,
                    isPresenting: $viewModel.isPresentingPrivacy)
        }

        .onChange(of: viewModel.isPatrao) { _, value in
            viewModel.storage.update(patrao: value)
        }
    }

    @ViewBuilder
    private func sectionSubscription(_ count: Int) -> some View {
        VStack {
            ForEach(0..<count, id: \.self) { _ in
                SubscriptionItemView(product: SubscriptionItemView.Product(title: "Assinatura Mensal",
                                                                           duration: "1 mês",
                                                                           price: "R$ 99,90",
                                                                           identifier: nil,
                                                                           accessibility: "Carregando opções de assinaturas."),
                                     selectedProduct: .constant(""))
            }
        }
    }

    @ViewBuilder
    private var sectionSubscription: some View {
        VStack {
            ForEach(viewModel.products, id: \.identifier) { product in
                SubscriptionItemView(product: SubscriptionItemView.Product(title: product.title ?? "",
                                                                           duration: product.subscription ?? "...",
                                                                           price: product.price ?? "",
                                                                           identifier: product.identifier ?? UUID().uuidString,
                                                                           accessibility: accessibilityLabel(subscription: product.subscription,
                                                                                                             price: product.price)),
                                     selectedProduct: $selectedProduct)
            }
        }
    }

    private func accessibilityLabel(subscription: String?,
                                    price: String?) -> String {
        "Assine o App para remover propagandas por \(subscription ?? "tempo desconhecido") pagando \(price ?? "valor desconhecido")."
    }

    @ViewBuilder
    private var subscribe: some View {
        if let selectedProduct {
            Button(action: { viewModel.purchase(selectedProduct) },
                   label: {
                Text("Assinar".uppercased())
                    .roundedFullSize(fill: theme.button.primary.color ?? .blue)
            })
            .accessibilityLabel("Assine o App para remover propagandas.")
        }
    }

    @ViewBuilder
    private var subscriptionOptions: some View {
        HStack {
            Button(action: { viewModel.restore() },
                   label: {
                Text("Recuperar".uppercased())
                    .borderedFullSize(color: theme.button.primary.color ?? .blue,
                                      stroke: theme.button.primary.color ?? .blue)
            })
            .accessibilityLabel("Recupere assinaturas previamente feitas.")

            manageSubscription
        }
    }

    @ViewBuilder
    private var manageSubscription: some View {
        Button(action: { viewModel.manageSubscriptions() },
               label: {
            Text("Gerenciar".uppercased())
                .borderedFullSize(color: theme.button.primary.color ?? .blue,
                                  stroke: theme.button.primary.color ?? .blue)
        })
        .accessibilityLabel("Gerencia suas assinaturas do App.")
    }

    @ViewBuilder
    private var sectionPatrao: some View {
        Button(action: { viewModel.isPresentingLoginPatrao.toggle() },
               label: {
            Text("Sou patrão".uppercased())
                .roundedFullSize(fill: theme.button.primary.color ?? .blue)
        })
        .accessibilityLabel("Fazer login como patrão para remover propagandas.")
    }
}

#Preview {
    VStack {
        SubscriptionView()
        Spacer()
    }
    .padding()
    .environmentObject(SettingsViewModel())
    .environment(\.theme, ThemeColor())
}
