import CommonLibrary
import SwiftUI
import UIComponentsLibrary

public struct PushOptionsView: View {
	@Environment(\.theme) private var theme: ThemeColor
	@EnvironmentObject private var viewModel: SettingsViewModel

	public init() {}

	public var body: some View {
		Section(header: Text("Notificações")
			.font(.headline)
			.foregroundColor(theme.text.terciary.color)) {
				SettingsTips.notifications.tipView(with: theme)
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
