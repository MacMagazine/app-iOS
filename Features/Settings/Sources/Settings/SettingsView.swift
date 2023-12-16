import CommonLibrary
import SwiftUI
import UIComponentsLibrary

public struct SettingsView: View {
	@Environment(\.theme) private var theme: ThemeColor
	@EnvironmentObject private var viewModel: SettingsViewModel

	public init() {
	}

	public var body: some View {
		NavigationStack(theme: theme, displayMode: .large, title: "Ajustes", content: {
			List {
				SubscriptionView()
				AppearanceView(theme: theme)
				PushOptionsView()

				Text("Posts -> multi")
				Text("Sobre -> + options")
			}
			.buttonStyle(PlainButtonStyle())
		})
		.preferredColorScheme(viewModel.mode.colorScheme)

		.task {
			try? await viewModel.getPurchasableProducts()
		}

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
	}
}

#Preview {
	SettingsView()
		.environment(\.theme, ThemeColor())
		.environmentObject(SettingsViewModel())
}

