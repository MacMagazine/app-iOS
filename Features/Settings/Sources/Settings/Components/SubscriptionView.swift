import CommonLibrary
import SwiftUI
import TipKit
import UIComponentsLibrary

struct SubscriptionView: View {
	@ObservedObject private var viewModel: SettingsViewModel
	private let theme: ThemeColor
	@State private var width: CGFloat?

	init(viewModel: SettingsViewModel,
		 theme: ThemeColor) {
		self.viewModel = viewModel
		self.theme = theme
	}

	var body: some View {
		Section(content: {
			SettingsTips.subscriptions.tipView(with: theme)
				.listRowBackground(Color.clear)

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
					sectionSubscription(ids: products)
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

		}, header: {
			Text("Remover Propagandas")
				.font(.headline)
				.foregroundColor(theme.text.primary.color)

		}, footer: {
			HStack {
				Button(action: {},
					   label: {
					Text("Termos de Uso")
						.bordered(stroke: .clear)
				})
				Spacer(minLength: 0)
				Button(action: {},
					   label: {
					Text("Política de Privacidade")
						.bordered(stroke: .clear)
				})
			}
			.frame(height: 20)
		})
		.listRowSeparator(.hidden)
	}

	@ViewBuilder
	private func sectionSubscription(ids: [String]) -> some View {
		ScrollView(.horizontal) {
			HStack {
				ForEach(ids, id: \.self) { _ in
					VStack {
						Text("R$ 10,90")
							.roundedFullSize(fill: theme.button.primary.color ?? .blue)
						Text("por 1 mês")
							.font(.caption)
							.foregroundStyle(theme.text.terciary.color ?? .black)
					}
					.redacted(reason: .placeholder)
					.frame(width: 130)
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
		.onAppear {
			viewModel.getProducts(using: ids)
		}
	}

	@ViewBuilder
	private var sectionSubscription: some View {
		ScrollView(.horizontal) {
			HStack {
				ForEach(viewModel.products, id: \.identifier) { _ in
					Button(action: {},
						   label: {
						VStack {
//							Text("R$ 10,90")
//								.roundedFullSize(fill: theme.button.primary.color ?? .blue)
//							Text("por 1 mês")
//								.font(.caption)
//								.foregroundStyle(theme.text.terciary.color ?? .black)
						}
					})
					.frame(width: 130)
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
			Button(action: {},
				   label: {
				Text("Recuperar".uppercased())
					.roundedFullSize(fill: theme.button.primary.color ?? .blue)
			})

			manageSubscription
		}
		.buttonStyle(PlainButtonStyle())
		.listRowBackground(Color.clear)
	}

	@ViewBuilder
	private var manageSubscription: some View {
		Button(action: {},
			   label: {
			Text("Gerenciar".uppercased())
				.roundedFullSize(fill: theme.button.primary.color ?? .blue)
		})
		.buttonStyle(PlainButtonStyle())
		.listRowBackground(Color.clear)
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
	}
}

#Preview {
	List {
		SubscriptionView(viewModel: SettingsViewModel(), theme: ThemeColorImplementation())
	}
}

@available(iOS 17, *)
struct SubscriptionsTip: Tip {
	@Parameter
	static var isActive: Bool = true

	var title: Text { Text("Remover propagandas") }
	var message: Text? { Text("Navegue pelo app sem propagandas - ou, alternativamente, use seu login de patrão.") }

	var rules: [Rule] = [
		#Rule(Self.$isActive) { $0 == true }
	]

	var actions: [Action] {
		SettingsTips.subscriptions.add { tip in
			(tip as? SettingsTips)?.show()
		}
	}
}
