import Combine
import CoreData
import CoreLibrary
import Foundation

public class NewsViewModel: ObservableObject {
	@Published public var fullScreen: Bool = false
	@Published public var category: Category = .news
	@Published var status: Status = .loading

	enum Status: Equatable {
		case loading
		case done
		case error(reason: String)

		var reason: String? {
			switch self {
			case .error(let reason):
				return reason
			default:
				return nil
			}
		}
	}

	public enum Category: String, CaseIterable {
		case highlights = "Destaques"
		case news = ""
		case podcast = "MacMagazine no Ar"
		case youtube = "Vídeos"
		case appletv = "Apple TV+"
		case reviews = "Review"
		case tutoriais = "Tutoriais"
		case rumors = "Rumores"

		var title: String {
			switch self {
			case .highlights: "Destaques"
			case .news: "Notícias"
			case .podcast: "MacMagazine no Ar"
			case .youtube: "Vídeos"
			case .appletv: "Novidades AppleTV+"
			case .reviews: "Reviews"
			case .tutoriais: "Tutoriais"
			case .rumors: "Rumores"
			}
		}
	}

	public let mainContext: NSManagedObjectContext
	let storage: Database
	let customHost: CustomHost?
	let mock: [String: String]?

	public init(customHost: CustomHost? = nil,
				mock: [String: String]? = nil) {
		self.customHost = customHost
		self.mock = mock
		self.storage = Database(db: "NewsModel",
								resource: Bundle.module.url(forResource: "NewsModel", withExtension: "momd"))
		self.mainContext = self.storage.mainContext
	}

	@MainActor
	public func getNews() async throws {
		do {
			status = .loading
			let news = try await loadNews()
			status = .done
			storage.save(news)
		} catch {
			status = .error(reason: (error as? NetworkAPIError)?.description ?? error.localizedDescription)
		}
	}
}

extension NewsViewModel {
	private func loadNews() async throws -> [XMLPost] {
		do {
			let endpoint = Endpoint.posts(customHost: customHost, paged: 0)

			MockURLProtocol(bundle: .module).mock(api: endpoint.restAPI, file: mock?[endpoint.restAPI])
			let data = try await NetworkAPI(mock: mock).get(url: endpoint.url)
			return try await withCheckedThrowingContinuation { continuation in
				parse(data, numberOfPosts: 3, parseFullContent: false, continuation: continuation)
			}

		} catch {
			throw error
		}
	}
}

extension NewsViewModel {
	private func parse(_ data: Data, numberOfPosts: Int, parseFullContent: Bool, continuation: CheckedContinuation<[XMLPost], Error>?) {
		let parser = XMLParser(data: data)
		let apiParser = APIXMLParser(numberOfPosts: numberOfPosts,
									 parseFullContent: parseFullContent,
									 continuation: continuation)
		parser.delegate = apiParser
		parser.parse()
	}
}
