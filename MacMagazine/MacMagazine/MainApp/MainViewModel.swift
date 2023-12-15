import Combine
import CommonLibrary
import Settings
import SwiftUI

enum Views: String {
	case splash
	case home
	case settings
}

class MainViewModel: ObservableObject {

	// MARK: - Properties -

	@Published public var currentView: Views = Views.splash

	@ObservedObject var settingsViewModel = SettingsViewModel()
	let theme = ThemeColor()

	private var cancellables: Set<AnyCancellable> = []

	// MARK: - Init -

	init() {
		settingsViewModel.$mode
			.sink { mode in
				print(mode.rawValue)
			}
			.store(in: &cancellables)
	}
}
