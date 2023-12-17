import CommonLibrary
import Settings
import SwiftUI

class MainViewModel: ObservableObject {

	// MARK: - Properties -

	@ObservedObject var settingsViewModel = SettingsViewModel()
	let theme = ThemeColor()

	// MARK: - Init -

	init() {
	}
}
