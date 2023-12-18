import CommonLibrary
import SwiftUI
import UIComponentsLibrary

public struct PostsVisibilityView: View {
	@Environment(\.theme) private var theme: ThemeColor
	@EnvironmentObject private var viewModel: SettingsViewModel

	public init() {}

	public var body: some View {
		Section(content: {
			Button(action: {},
				   label: {
				Text("Marcar todos os posts como lidos".uppercased())
					.roundedFullSize(fill: theme.button.primary.color ?? .blue)
			})

			Toggle("Identificar posts já lidos", isOn: $viewModel.postRead)
				.tint(theme.button.primary.color)
			Toggle("Contar posts não lidos no ícone do app", isOn: $viewModel.countOnBadge)
				.tint(theme.button.primary.color)
				.disabled(!viewModel.postRead)

			DisclosureGroup(content: {
				Button(action: {},
					   label: {
					Text("manter favoritos e status de leitura".uppercased())
						.roundedFullSize(fill: theme.button.primary.color ?? .blue)
				})
				Button(action: {},
					   label: {
					Text("manter status de leitura".uppercased())
						.roundedFullSize(fill: theme.button.primary.color ?? .blue)
				})
				Button(action: {},
					   label: {
					Text("manter favoritos".uppercased())
						.roundedFullSize(fill: theme.button.primary.color ?? .blue)
				})
				Button(action: {},
					   label: {
					Text("Apagar somente as images".uppercased())
						.borderedFullSize(color: theme.button.primary.color ?? .blue,
										  stroke: theme.button.primary.color ?? .blue)
				})
				Button(action: {},
					   label: {
					Text("Limpar tudo".uppercased())
						.borderedFullSize(color: theme.button.destructive.color ?? .blue,
										  stroke: theme.button.destructive.color ?? .blue)
				})

			}, label: {
				Text("Limpar cache do app")
			})
			.tint(theme.main.tint.color)

		})
		.listRowSeparator(.hidden)
		.listRowBackground(Color.clear)
		.buttonStyle(PlainButtonStyle())
    }
}

#Preview {
	List {
		PostsVisibilityView()
			.environment(\.theme, ThemeColor())
			.environmentObject(SettingsViewModel())
	}
}
