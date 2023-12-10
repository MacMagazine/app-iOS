import CommonLibrary
import SwiftUI
import TipKit
import UIComponentsLibrary

struct SubscriptionView: View {
	@ObservedObject private var viewModel: SettingsViewModel
	private let theme: ThemeColor

	init(viewModel: SettingsViewModel,
		 theme: ThemeColor) {
		self.viewModel = viewModel
		self.theme = theme
	}

	var body: some View {
		Section(header: Text("Remover Propagandas")
			.font(.headline)
			.foregroundColor(theme.text.primary.color)) {
				SettingsTips.subscriptions.tipView(with: theme)

				if viewModel.isPatrao {
					logoffPatrao
						.padding(.vertical, 4)
						.listRowBackground(theme.main.background.color)

				} else {
					Text("Assinaturas -> [] + options")
						.foregroundColor(theme.text.primary.color)

					patrao
						.padding(.vertical, 4)
						.listRowBackground(theme.main.background.color)
				}
			}
			.buttonStyle(PlainButtonStyle())
	}

	@ViewBuilder
	private var patrao: some View {
		Button(action: { viewModel.isPresentingLoginPatrao.toggle() },
			   label: {
			Text("Sou patrão")
		})
	}

	@ViewBuilder
	private var logoffPatrao: some View {
		Button(action: { viewModel.isPatrao = false },
			   label: {
			Text("Logoff de patrão")
		})
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
