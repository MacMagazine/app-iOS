import Combine
import CommonLibrary
import CoreLibrary
import Settings
import SwiftUI
import Videos

class MainViewModel: ObservableObject {

	// MARK: - Definitions -

	enum Page {
		case home
		case videos
	}

	struct Section: Identifiable {
		let id = UUID().uuidString
		let title: String
		let action: () -> Void
	}

	// MARK: - Properties -

	private var cancellables: Set<AnyCancellable> = []

	@ObservedObject var videosViewModel = VideosViewModel()
	@ObservedObject var settingsViewModel = SettingsViewModel()

	let theme = ThemeColor()

	@Published var selectedView: Page = .home

	let sections = [Section(title: "Notícias", action: {}),
					Section(title: "YouTube", action: {})]

	// MARK: - Init -

	init() {
		observe()
	}
}

extension MainViewModel {
	private func observe() {
		settingsViewModel.$cache
			.receive(on: RunLoop.main)
			.compactMap { $0 }
			.removeDuplicates()
			.sink { value in
				print("value: \(value)")
			}
			.store(in: &cancellables)

		videosViewModel.$options
			.receive(on: RunLoop.main)
			.compactMap { $0 }
			.removeDuplicates()
			.sink { [weak self] value in
				switch value {
				case .all:
					self?.selectedView = .videos
				case .home:
					self?.selectedView = .home
				default: break
				}
			}
			.store(in: &cancellables)
	}
}
