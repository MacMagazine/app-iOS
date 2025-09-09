import Combine
import CommonLibrary
import CoreData
import CoreLibrary
import Foundation

public struct NewsToShow {
    let title: String
    let url: String
    
    var favorite: Bool {
        didSet {
            action?(favorite)
        }
    }
    
    let action: ((Bool) -> Void)?
}

public class NewsViewModel: ObservableObject {
	@Published public var options: Options = .home
    @Published public var newsToShow: NewsToShow = NewsToShow(title: "", url: "", favorite: false, action: nil)
	@Published public var category: Category = .news
	@Published public var status: Status = .loading

	public enum Options: Equatable {
		case all
		case home
		case favourites
		case search(text: String)
		case filter(category: Category)
	}

	public enum Status: Equatable {
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
        case all = "Todas"

		var query: (String, String)? {
			switch self {
			case .highlights: (APIParams.cat, "674")
            case .news, .all: nil
			case .podcast: (APIParams.cat, "101")
			case .youtube: (APIParams.cat, "18")
			case .appletv: (APIParams.tag, "apple-tv-plus")
			case .reviews: (APIParams.tag, "review")
			case .tutoriais: (APIParams.cat, "302")
			case .rumors: (APIParams.cat, "12")
			}
		}

		func filter(source: String?) -> Bool {
			switch self {
            case .all: true
			case .highlights: (source?.contains(NewsViewModel.Category.highlights.rawValue) ?? false)
			case .news: !(source?.contains(NewsViewModel.Category.highlights.rawValue) ?? true)
			case .podcast: (source?.contains(NewsViewModel.Category.podcast.rawValue) ?? false)
			case .youtube: (source?.contains(NewsViewModel.Category.youtube.rawValue) ?? false)
			case .appletv: (source?.contains(NewsViewModel.Category.appletv.rawValue) ?? false)
			case .reviews: (source?.contains(NewsViewModel.Category.reviews.rawValue) ?? false)
			case .tutoriais: (source?.contains(NewsViewModel.Category.tutoriais.rawValue) ?? false)
			case .rumors: (source?.contains(NewsViewModel.Category.rumors.rawValue) ?? false)
			}
		}

		var header: String {
			switch self {
			case .highlights: "Destaques"
			case .news: "Últimas Notícias"
			case .podcast: "MacMagazine no Ar"
			case .youtube: "Vídeos"
			case .appletv: "Novidades AppleTV+"
			case .reviews: "Reviews"
			case .tutoriais: "Tutoriais"
			case .rumors: "Rumores"
            case .all: ""
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
            case .all: ""
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

        var showHeader: Bool { true }

        var headerType: HeaderButtonType {
            switch self {
            case .highlights, .news: .none
            default: .none // .text("Mais")
            }
        }
        var showMore: Bool {
            switch self {
            case .highlights, .news: false
            default: false
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
				mock: [String: String]? = nil,
                inMemory: Bool = false) {
		self.customHost = customHost
		self.mock = mock

        var storeDescriptions: [DatabaseConfig.StoreDescription] = []
        if inMemory {
            storeDescriptions.append(DatabaseConfig.StoreDescription(name: "Local", type: .inMemory))
        } else {
            storeDescriptions.append(DatabaseConfig.StoreDescription(name: "Local", type: .local))
            storeDescriptions.append(DatabaseConfig.StoreDescription(name: "Cloud", type: .cloud("iCloud.com.brit.beta.macmagazine")))
        }
        self.storage = Database(config: DatabaseConfig(database: "NewsModel",
                                                       resource: Bundle.module.url(forResource: "NewsModel", withExtension: "momd"),
                                                       storeDescriptions: storeDescriptions))

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
			_ = try await [highlights, appletv, reviews, tutoriais, rumors, posts]
			status = .done
		} catch {
			status = .error(reason: (error as? NetworkAPIError)?.description ?? error.localizedDescription)
		}
	}
}

extension NewsViewModel {
    func filter(source: String?) -> NewsViewModel.Category {
        var categories: [NewsViewModel.Category] = []
        if source?.contains(NewsViewModel.Category.highlights.rawValue) ?? false {
            categories.append(.highlights)
        }
        if source?.contains(NewsViewModel.Category.rumors.rawValue) ?? false {
            categories.append(.rumors)
        }
        if source?.contains(NewsViewModel.Category.tutoriais.rawValue) ?? false {
            categories.append(.tutoriais)
        }
        if source?.contains(NewsViewModel.Category.reviews.rawValue) ?? false {
            categories.append(.reviews)
        }
        if source?.contains(NewsViewModel.Category.appletv.rawValue) ?? false {
            categories.append(.appletv)
        }
        if source?.contains(NewsViewModel.Category.youtube.rawValue) ?? false {
            categories.append(.youtube)
        }
        if source?.contains(NewsViewModel.Category.podcast.rawValue) ?? false {
            categories.append(.podcast)
        }
        return categories.last ?? .news
    }
}

extension NewsViewModel {
	private func loadNews(query: Category) async throws -> [XMLPost] {
		do {
			let endpoint = Endpoint.posts(customHost: customHost, paged: 0, query: query.query)

			MockURLProtocol(bundle: .module).mock(api: endpoint.restAPI, file: mock?[endpoint.restAPI])
			let data = try await NetworkAPI(mock: mock).get(url: endpoint.url)
			let object = try await withCheckedThrowingContinuation { continuation in
				parse(data, category: query.rawValue, numberOfPosts: -1, parseFullContent: false, continuation: continuation)
			}
			storage.save(object)
			return object
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
