import CommonLibrary
import SwiftUI
import TipKit
import UIComponentsLibrary

struct PushOptionsView: View {
	@Environment(\.theme) private var theme: ThemeColor
	@EnvironmentObject private var viewModel: SettingsViewModel

	var body: some View {
		Section(header: Text("Notificações")
			.font(.headline)
			.foregroundColor(theme.text.primary.color)) {
				SettingsTips.subscriptions.tipView(with: theme)
					.listRowBackground(Color.clear)

				optionsView
					.listRowBackground(Color.clear)
			}
			.listRowSeparator(.hidden)
			.buttonStyle(PlainButtonStyle())
	}
}

extension PushOptionsView {
	@ViewBuilder
	private var optionsView: some View {
		Picker("", selection: $viewModel.notificationType) {
			Text("Todos os posts").tag(PushPreferences.all)
				.accessibilityLabel(PushPreferences.all.accessibilityText(selected: viewModel.notificationType == PushPreferences.all))

			Text("Somente destaques").tag(PushPreferences.featured)
				.accessibilityLabel(PushPreferences.featured.accessibilityText(selected: viewModel.notificationType == PushPreferences.featured))
		}
		.pickerStyle(.segmented)
		.onChange(of: viewModel.notificationType) { value in
			Task { await viewModel.change(value) }
		}
	}
}

#Preview {
	List {
		PushOptionsView()
	}
}

@available(iOS 17, *)
struct PushNotificationTip: Tip {
	@Parameter
	static var isActive: Bool = true

	var title: Text { Text("Push Notifications") }
	var message: Text? { Text("Receba notificações toda vez que um novo post for publicado. Escolha entre qualquer novo post ou somente os posts em Destaque.") }

	var rules: [Rule] = [
		#Rule(Self.$isActive) { $0 == true }
	]

	var actions: [Action] {
		SettingsTips.notifications.add { tip in
			(tip as? SettingsTips)?.show()
		}
	}
}
