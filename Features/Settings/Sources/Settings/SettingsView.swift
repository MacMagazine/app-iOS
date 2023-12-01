import CommonLibrary
import SwiftUI
import UIComponentsLibrary

public struct SettingsView: View {
	@Environment(\.theme) var theme: ThemeColor
	@ObservedObject private var viewModel: SettingsViewModel

	public init(viewModel: SettingsViewModel = SettingsViewModel()) {
		self.viewModel = viewModel
	}

	public var body: some View {
		NavigationStack(theme: theme, displayMode: .large, title: "Ajustes", content: {
			List {
				Section(header: Text("Ícone do app")
					.font(.headline)
					.foregroundColor(theme.text.primary.color)) {
						icons.listRowBackground(theme.main.background.color)
					}
					.buttonStyle(PlainButtonStyle())

				Text("Assinaturas -> [] + options")
					.foregroundColor(theme.text.primary.color)
				Text("Push -> segment")
				Text("Aparência -> segment")
				Text("Posts -> multi")
				Text("Sobre -> + options")
			}
		})
		.task {
			await viewModel.setSettings()
		}
	}
}

extension SettingsView {
	@ViewBuilder
	private var icons: some View {
		HStack(spacing: 12) {
			Spacer()

			ForEach(IconType.allCases, id: \.self) { type in
				Button(action: { Task { await viewModel.change(type) }},
					   label: {
					Image(type.rawValue, bundle: .module)
						.resizable()
						.aspectRatio(contentMode: .fit)
				})
				.frame(width: 70, height: 70)
				.cornerRadius(12)
				.overlay(RoundedRectangle(cornerRadius: 12,
										  style: .continuous)
					.stroke(theme.text.primary.color ?? .blue, lineWidth: viewModel.icon == type ? 3 : 0)
				)
				.disabled(viewModel.icon == type)
				.opacity(viewModel.icon == type ? 0.5 : 1)
			}

			Spacer()
		}
	}
}

#Preview {
	SettingsView()
		.environment(\.theme, ThemeColorImplementation())
}
