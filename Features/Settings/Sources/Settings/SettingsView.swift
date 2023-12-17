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
				Text("Posts -> multi")
			}
			.buttonStyle(PlainButtonStyle())
		})
	}
}

#Preview {
	SettingsView()
		.environment(\.theme, ThemeColor())
		.environmentObject(SettingsViewModel())
}

