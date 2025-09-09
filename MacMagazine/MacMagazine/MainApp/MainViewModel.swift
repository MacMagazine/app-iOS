import Combine
import CommonLibrary
import CoreLibrary
import News
import Settings
import SwiftUI
import Videos

class MainViewModel: ObservableObject {

	// MARK: - Definitions -

    enum Page {
        case home
        case news
        case videos
        case highlights
        case podcast
        case appletv
        case reviews
        case tutoriais
        case rumors
        case favourites
        case settings
        case search
    }

    enum Tabs {
		case home
        case favourites
        case settings
        case categories
        case search
	}

	struct Section: Identifiable {
		let id = UUID().uuidString
		let title: String
		let page: Page
	}

	// MARK: - Properties -

	private var cancellables: Set<AnyCancellable> = []

	@ObservedObject var videosViewModel = VideosViewModel()
	@ObservedObject var settingsViewModel = SettingsViewModel()
    @ObservedObject var newsViewModel = NewsViewModel()

	let theme = ThemeColor()

	@Published var isLoading: Bool = false

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

        newsViewModel.$status
			.receive(on: RunLoop.main)
			.compactMap { $0 }
			.sink { [weak self] value in
				self?.isLoading = value == .loading
			}
			.store(in: &cancellables)
	}
}
