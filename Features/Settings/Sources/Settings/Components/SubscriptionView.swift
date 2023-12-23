import CommonLibrary
import SwiftUI
import UIComponentsLibrary

public struct SubscriptionView: View {
	@Environment(\.theme) private var theme: ThemeColor
	@EnvironmentObject private var viewModel: SettingsViewModel

	@State private var width: CGFloat?

	public init() {}

	public var body: some View {
		Section(content: {
			if viewModel.isPatrao {
				Button(action: { viewModel.isPatrao = false },
					   label: {
					Text("Logoff de patrão".uppercased())
						.roundedFullSize(fill: theme.button.primary.color ?? .blue)
				})
				.padding(.vertical, 4)
				.buttonStyle(PlainButtonStyle())
				.listRowBackground(Color.clear)

			} else if viewModel.subscriptionValid {
				manageSubscription

			} else {
				switch viewModel.status {
				case .done:
					sectionSubscription
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
						.listRowBackground(Color.clear)
				case .error(let reason):
					ErrorView(message: reason)
						.listRowBackground(Color.clear)
					subscriptionOptions
				}

				sectionPatrao
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
			.listRowBackground(Color.clear)
		})
		.listRowSeparator(.hidden)

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

		.onChange(of: viewModel.isPatrao) { value in
			viewModel.storage.update(patrao: value)
		}
	}

	@ViewBuilder
	private func sectionSubscription(_ count: Int) -> some View {
		ScrollView(.horizontal) {
			HStack {
				ForEach(0..<count, id: \.self) { _ in
					VStack {
						Text("R$ 10,90")
							.roundedFullSize(fill: theme.button.primary.color ?? .blue)
						Text("por 1 mês")
							.font(.caption)
							.foregroundStyle(theme.text.terciary.color ?? .black)
					}
					.redacted(reason: .placeholder)
					.frame(width: 130)
					.accessibilityLabel("Carregando opções de assinaturas.")
				}
			}
			.frame(minWidth: width)
		}
		.buttonStyle(PlainButtonStyle())
		.listRowBackground(Color.clear)
		.background(GeometryReader { proxy in
			Color.clear.onAppear {
				width = proxy.size.width
			}
		})
	}

	@ViewBuilder
	private var sectionSubscription: some View {
		ScrollView(.horizontal) {
			HStack {
				ForEach(viewModel.products, id: \.identifier) { product in
					Button(action: { viewModel.purchase(product) },
						   label: {
						VStack {
							Text(product.price ?? "")
								.roundedFullSize(fill: theme.button.primary.color ?? .blue)
							Text("por " + (product.subscription ?? "..."))
								.font(.caption)
								.foregroundStyle(theme.text.terciary.color ?? .black)
						}
					})
					.frame(width: 130)
					.accessibilityLabel("Assine o App para remover propagandas por \(product.subscription ?? "tempo desconhecido") pagando \(product.price ?? "valor desconhecido").")
				}
			}
			.frame(minWidth: width)
		}
		.buttonStyle(PlainButtonStyle())
		.listRowBackground(Color.clear)
		.background(GeometryReader { proxy in
			Color.clear.onAppear {
				width = proxy.size.width
			}
		})
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
		.buttonStyle(PlainButtonStyle())
		.listRowBackground(Color.clear)
	}

	@ViewBuilder
	private var manageSubscription: some View {
		Button(action: { viewModel.manageSubscriptions() },
			   label: {
			Text("Gerenciar".uppercased())
				.borderedFullSize(color: theme.button.primary.color ?? .blue,
								  stroke: theme.button.primary.color ?? .blue)
		})
		.buttonStyle(PlainButtonStyle())
		.listRowBackground(Color.clear)
		.accessibilityLabel("Gerencia suas assinaturas do App.")
	}

	@ViewBuilder
	private var sectionPatrao: some View {
		Button(action: { viewModel.isPresentingLoginPatrao.toggle() },
			   label: {
			Text("Sou patrão".uppercased())
				.roundedFullSize(fill: theme.button.primary.color ?? .blue)
		})
		.padding(.vertical, 4)
		.buttonStyle(PlainButtonStyle())
		.listRowBackground(Color.clear)
		.accessibilityLabel("Fazer login como patrão para remover propagandas.")
	}
}

#Preview {
	List {
		SubscriptionView()
			.environment(\.theme, ThemeColor())
			.environmentObject(SettingsViewModel())
	}
}
