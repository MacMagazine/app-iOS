import CommonLibrary
import SwiftUI
import UIComponentsLibrary

public struct SettingsView: View {
	@Environment(\.theme) var theme: ThemeColor
	@ObservedObject private var viewModel: SettingsViewModel

	public init(viewModel: SettingsViewModel) {
		self.viewModel = viewModel
	}

	public var body: some View {
		NavigationStack(theme: theme, displayMode: .large, title: "Ajustes", content: {
			List {
				AppearanceView(viewModel: viewModel, theme: theme)

				SettingsTips.subscriptions.tipView(with: theme)
				Text("Assinaturas -> [] + options")
					.foregroundColor(theme.text.primary.color)
				Text("Push -> segment")
				Text("Posts -> multi")
				Text("Sobre -> + options")
			}
		})
		.task {
			await viewModel.setSettings()
		}
	}
}

#Preview {
	SettingsView(viewModel: SettingsViewModel())
		.environment(\.theme, ThemeColorImplementation())
}

