import Combine
import Foundation
import NetworkLibrary
import StorageLibrary
import SwiftData

@MainActor @Observable
public class FeedViewModel {
    public var status: Status = .loading

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

    let storage: Database
    let networkService: NetworkService

    public var context: ModelContext { storage.context }

    public init(
        network: Network? = nil,
        storage: Database
    ) {
        self.storage = storage
        self.networkService = NetworkService(network: network)
    }

    public func getNews() async throws {
        do {
            status = .loading
            async let highlights = fetch(category: .highlights)
            async let appletv = fetch(category: .appletv)
            async let reviews = fetch(category: .reviews)
            async let tutoriais = fetch(category: .tutoriais)
            async let rumors = fetch(category: .rumors)
            async let posts = fetch(category: .news)
            _ = try await [highlights, appletv, reviews, tutoriais, rumors, posts]
            status = .done
        } catch {
            status = .error(reason: (error as? NetworkAPIError)?.description ?? error.localizedDescription)
        }
    }

    public func getPodcast() async throws {
        do {
            status = .loading
            let podcasts = try await fetch(category: .podcast)
            storage.save(podcast: podcasts.toPodcastDB)
            status = .done
        } catch {
            status = .error(reason: (error as? NetworkAPIError)?.description ?? error.localizedDescription)
        }
    }
}

extension FeedViewModel {
    private func fetch(category: Category) async throws -> [XMLPost] {
        do {
            let data = try await networkService.fetch(category: category)
            return try await withCheckedThrowingContinuation { continuation in
                Self.parse(
                    data,
                    category: category.rawValue,
                    numberOfPosts: -1,
                    parseFullContent: false,
                    continuation: continuation)
            }

        } catch {
            throw error
        }
    }
}

extension FeedViewModel {
    private static func parse(
        _ data: Data,
        category: String,
        numberOfPosts: Int,
        parseFullContent: Bool,
        continuation: CheckedContinuation<[XMLPost], Error>?
    ) {
        let parser = XMLParser(data: data)
        let apiParser = APIXMLParser(numberOfPosts: numberOfPosts,
                                     category: category,
                                     parseFullContent: parseFullContent,
                                     continuation: continuation)
        parser.delegate = apiParser
        parser.parse()
    }
}
