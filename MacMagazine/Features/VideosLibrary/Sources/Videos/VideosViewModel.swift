import Combine
import Foundation
import NetworkLibrary
import StorageLibrary
import UIComponentsLibrary
import YouTubeLibrary

@Observable
class VideosViewModel {
	var options: Options = .home
	var status: APIStatus = .loading

	enum Options: Equatable {
		case home
		case search(text: String)
	}

    private let storage: Database
    private let mock: [NetworkMockData]?
    let youtube: YouTubeAPI

    let credentials = YouTubeCredentials(salt: "AppDelegateNSObject",
										 keys: [
											[0, 57, 10, 37, 54, 21, 36, 2, 13, 46, 93, 125, 43, 45, 86, 5, 55, 5, 57, 59, 9, 58, 118, 32, 5, 12, 4, 51, 36, 52, 36, 60, 62, 9, 91, 36, 54, 30, 50]
										 ],
										 playlistId: [20, 37, 70, 30, 44, 1, 41, 16, 8, 61, 4, 24, 1, 22, 43, 45, 28, 0, 5, 41, 69, 25, 8, 36],
										 channelId: [20, 51, 70, 30, 44, 1, 41, 16, 8, 61, 4, 24, 1, 22, 43, 45, 28, 0, 5, 41, 69, 25, 8, 36])

    @MainActor
    init(storage: Database,
         mock: [NetworkMockData]? = nil) {
        self.storage = storage
        self.mock = mock

        self.youtube = YouTubeAPI(credentials: credentials,
                                  mock: mock,
                                  storage: storage,
                                  language: "pt-BR")
    }
}
