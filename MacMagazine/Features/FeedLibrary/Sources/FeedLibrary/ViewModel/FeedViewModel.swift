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

    public func getFeed(page: Int = 0) async throws {
        do {
            status = .loading
            async let highlights = fetch(category: .highlights, page: page)
            async let appletv = fetch(category: .appletv, page: page)
            async let reviews = fetch(category: .reviews, page: page)
            async let tutoriais = fetch(category: .tutoriais, page: page)
            async let rumors = fetch(category: .rumors, page: page)
            async let posts = fetch(category: .news, page: page)
            let feed = try await [highlights, appletv, reviews, tutoriais, rumors, posts]
            storage.save(feed: Array(feed.joined()).toFeedDB)
            status = .done
        } catch {
            status = .error(reason: (error as? NetworkAPIError)?.description ?? error.localizedDescription)
        }
    }

    public func getWidgetData(limit: Int = 3) async throws -> [WidgetData] {
        do {
            let data = try await fetch(category: .all, page: 0)
            return Array(data.prefix(limit)).toWidgetData
        } catch {
            status = .error(reason: (error as? NetworkAPIError)?.description ?? error.localizedDescription)
            return []
        }
    }

    public func getPodcast(page: Int = 1) async throws {
        do {
            status = .loading
            let podcasts = try await fetch(category: .podcast, page: page)
            storage.save(podcast: podcasts.toPodcastDB)
            status = .done
        } catch {
            status = .error(reason: (error as? NetworkAPIError)?.description ?? error.localizedDescription)
        }
    }

    @discardableResult
    public func getWatchFeed() async throws -> [FeedDB] {
        do {
            status = .loading
            let feed = try await fetch(category: .all, page: 0, parseFullContent: true)
            let watchData = Array(feed.prefix(10)).toFeedDB
            storage.save(feed: watchData)
            status = .done
            return watchData
        } catch {
            status = .error(reason: (error as? NetworkAPIError)?.description ?? error.localizedDescription)
            return []
        }
    }
}

extension FeedViewModel {
    private func fetch(
        category: Category,
        page: Int,
        parseFullContent: Bool = false
    ) async throws -> [XMLPost] {
        do {
            let data = try await networkService.fetch(category: category, page: page)
            return try await withCheckedThrowingContinuation { continuation in
                Self.parse(
                    data,
                    category: category.rawValue,
                    numberOfPosts: -1,
                    parseFullContent: parseFullContent,
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
