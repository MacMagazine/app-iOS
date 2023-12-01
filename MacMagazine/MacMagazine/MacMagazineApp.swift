import CommonLibrary
import Settings
import SwiftUI
import UIComponentsLibrary

@main
struct MacMagazineApp: App {
    var body: some Scene {
        WindowGroup {
			SettingsView()
        }
		.environment(\.theme, ThemeColorImplementation())
    }
}
