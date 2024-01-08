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

	@Published var selectedTab: Page = .home
	@Published var selectedSection: Page = .highlights

	let sections = [Section(title: "Destaques", page: .highlights),
					Section(title: "Notícias", page: .news),
					Section(title: "Vídeos", page: .videos),
					Section(title: "Podcast", page: .podcast)]

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
			.sink { [weak self] value in
				switch value {
				case .all:
					self?.selectedTab = .videos
				case .home:
					self?.selectedTab = .home
				default: break
				}
			}
			.store(in: &cancellables)
	}
}
