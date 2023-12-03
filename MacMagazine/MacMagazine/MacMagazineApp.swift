import CommonLibrary
import Settings
import SwiftUI
import TipKit
import UIComponentsLibrary

@main
struct MacMagazineApp: App {
	var body: some Scene {
		WindowGroup {
			SettingsView()
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
