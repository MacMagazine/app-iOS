import Combine
import CoreData
import CoreLibrary
import Foundation

public class NewsViewModel: ObservableObject {
	@Published public var fullScreen: Bool = false
	@Published public var options: Options = .home
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

	public enum Options: Equatable {
		case all
		case home
		case favorite
		case search(text: String)
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
	func getNews() async throws {
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
