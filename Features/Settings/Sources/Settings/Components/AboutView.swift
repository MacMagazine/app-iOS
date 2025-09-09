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
				Text("Relatar problema/bug no app".uppercased())
					.borderedFullSize(color: theme.text.primary.color ?? .primary,
									  stroke: theme.button.secondary.color ?? .blue)
			})
            .frame(maxWidth: 540)

		}, header: {
                VStack(alignment: .leading) {
                    Text("SOBRE")
                        .font(.headline)
                    Text("VERSÃO \(Bundle.version ?? "")")
                        .font(.footnote)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
			.foregroundColor(theme.text.terciary.color)
			.accessibilityElement(children: .ignore)
			.accessibilityLabel("A versão do app é \(Bundle.version ?? "desconhecida").")
		}, footer: {
			footerView
                .frame(maxWidth: 540, alignment: .leading)
		})
	}
}

extension AboutView {
	@ViewBuilder
	private var footerView: some View {
		Text("MacMagazine é um [projeto de código aberto no GitHub](https://github.com/MacMagazine/app-iOS) liderado por Cassio Rossi.")
			.font(.caption)
			.foregroundColor(theme.text.terciary.color)
			.tint(theme.button.primary.color)
	}
}

#Preview {
    VStack {
        AboutView()
        Spacer()
    }
    .padding()
    .environmentObject(SettingsViewModel())
    .environment(\.theme, ThemeColor())
}
