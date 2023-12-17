import CommonLibrary
import SwiftUI
import UIComponentsLibrary

public struct AboutView: View {
	@Environment(\.theme) private var theme: ThemeColor
	@EnvironmentObject private var viewModel: SettingsViewModel

	public init() {}

	public var body: some View {
		Section(content: {
			Button(action: { viewModel.composeMessage() },
				   label: {
				Text("Relater problema/bug no app".uppercased())
					.borderedFullSize(color: theme.text.primary.color ?? .primary,
									  stroke: theme.button.secondary.color ?? .blue)
			})
			.buttonStyle(PlainButtonStyle())
			.listRowBackground(Color.clear)

		}, header: {
			VStack(alignment: .leading) {
				Text("Sobre")
					.font(.headline)
				Text("versão \(Bundle.version ?? "")")
					.font(.footnote)
			}
			.foregroundColor(theme.text.terciary.color)
			.accessibilityElement(children: .ignore)
			.accessibilityLabel("A versão do app é \(Bundle.version ?? "desconhecida").")
		}, footer: {
			footerView
				.listRowBackground(Color.clear)
		})
		.listRowSeparator(.hidden)
	}
}

extension AboutView {
	@ViewBuilder
	private var footerView: some View {
		Text("MacMagazine é um [projeto de código aberto no GitHub](https://github.com/MacMagazine/app-iOS) liderado por Cassio Rossi, da [KazzioSoftware](http://kazziosoftware.com).")
			.font(.caption)
			.foregroundColor(theme.text.terciary.color)
			.tint(theme.button.primary.color)
	}
}

#Preview {
	List {
		AboutView()
	}
}
