import Combine
import CommonLibrary
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
		case reviews = "Reviews"
		case tutoriais = "Tutoriais"
		case rumors = "Rumores"

		var query: (String, String)? {
			switch self {
			case .highlights: (APIParams.cat, "674")
			case .news: nil
			case .podcast: (APIParams.cat, "101")
			case .youtube: (APIParams.cat, "18")
			case .appletv: (APIParams.tag, "apple-tv-plus")
			case .reviews: (APIParams.tag, "review")
			case .tutoriais: (APIParams.cat, "302")
			case .rumors: (APIParams.cat, "12")
			}
		}

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

		var style: CardData.Style {
			switch self {
			case .highlights, .reviews: .highlight
			case .news: .imageLast
			case .podcast: .imageFirst
			case .tutoriais, .rumors: .imageFirst
			default: .simple
			}
		}

		var showHeader: Bool {
			switch self {
			case .highlights: false
			default: true
			}
		}

		var aspectRatio: Double {
			switch self {
			case .highlights: 4 / 3
			default: 1
			}
		}

		var spacing: CGFloat? {
			switch self {
			case .highlights: 2
			default: nil
			}
		}

		var width: CGFloat? {
			switch self {
			case .appletv: 100
			default: nil
			}
		}

		var height: CGFloat {
			switch self {
			case .news, .tutoriais, .rumors: 120
			case .appletv: 100
			default: .infinity
			}
		}

		var dateFormat: MMDateFormat {
			switch self {
			case .tutoriais, .rumors, .reviews: .mmDateOnly
			default: .mmDateTime
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
			async let highlights = loadNews(query: .highlights)
			async let appletv = loadNews(query: .appletv)
			async let reviews = loadNews(query: .reviews)
			async let tutoriais = loadNews(query: .tutoriais)
			async let rumors = loadNews(query: .rumors)
			async let posts = loadNews(query: .news)
			let news = try await [highlights, appletv, reviews, tutoriais, rumors, posts]
			status = .done
			storage.save(Array(news.joined()))
		} catch {
			status = .error(reason: (error as? NetworkAPIError)?.description ?? error.localizedDescription)
		}
	}
}

extension NewsViewModel {
	private func loadNews(query: Category) async throws -> [XMLPost] {
		do {
			let endpoint = Endpoint.posts(customHost: customHost, paged: 0, query: query.query)

			MockURLProtocol(bundle: .module).mock(api: endpoint.restAPI, file: mock?[endpoint.restAPI])
			let data = try await NetworkAPI(mock: mock).get(url: endpoint.url)
			return try await withCheckedThrowingContinuation { continuation in
				parse(data, category: query.rawValue, numberOfPosts: -1, parseFullContent: false, continuation: continuation)
			}

		} catch {
			throw error
		}
	}
}

extension NewsViewModel {
	private func parse(_ data: Data,category: String, numberOfPosts: Int, parseFullContent: Bool, continuation: CheckedContinuation<[XMLPost], Error>?) {
		let parser = XMLParser(data: data)
		let apiParser = APIXMLParser(numberOfPosts: numberOfPosts,
									 category: category,
									 parseFullContent: parseFullContent,
									 continuation: continuation)
		parser.delegate = apiParser
		parser.parse()
	}
}
