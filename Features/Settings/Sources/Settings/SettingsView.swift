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
				SubscriptionView(viewModel: viewModel, theme: theme)
				AppearanceView(viewModel: viewModel, theme: theme)

				Text("Push -> segment")
				Text("Posts -> multi")
				Text("Sobre -> + options")
			}
			.buttonStyle(PlainButtonStyle())
		})
		.task {
			await viewModel.setSettings()
		}

		.sheet(isPresented: $viewModel.isPresentingLoginPatrao) {
			Webview(title: "Login para patrões",
					url: APIParams.patraoLoginUrl,
					isPresenting: $viewModel.isPresentingLoginPatrao,
					navigationDelegate: WebviewController(isPresenting: $viewModel.isPresentingLoginPatrao,
														  isPatrao: $viewModel.isPatrao),
					userScripts: WebviewController().userScripts)
		}
	}
}

#Preview {
	SettingsView(viewModel: SettingsViewModel())
		.environment(\.theme, ThemeColorImplementation())
}

