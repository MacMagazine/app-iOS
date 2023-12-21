import Combine
import CommonLibrary
import Settings
import SwiftUI
import Videos

class MainViewModel: ObservableObject {

	// MARK: - Properties -

	private var cancellables: Set<AnyCancellable> = []

	@ObservedObject var videosViewModel = VideosViewModel()
	@ObservedObject var settingsViewModel = SettingsViewModel()
	let theme = ThemeColor()

	// MARK: - Init -

	init() {
		settingsViewModel.$cache
			.receive(on: RunLoop.main)
			.compactMap { $0 }
			.removeDuplicates()
			.sink { [weak self] value in
				print("value: \(value)")
			}
			.store(in: &cancellables)
	}
}
