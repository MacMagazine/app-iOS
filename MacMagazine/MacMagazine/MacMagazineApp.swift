import CommonLibrary
import Settings
import SwiftUI
import TipKit
import UIComponentsLibrary

@main
struct MacMagazineApp: App {
	@ObservedObject var settingsViewModel = SettingsViewModel()

	var body: some Scene {
		WindowGroup {
			SettingsView(viewModel: settingsViewModel)
				.preferredColorScheme(settingsViewModel.mode.colorScheme)
				.task {
					if #available(iOS 17, *) {
						#if DEBUG
						try? Tips.resetDatastore()
						#endif
						try? Tips.configure()
					}
				}
		}
		.environment(\.theme, ThemeColorImplementation())
	}
}
