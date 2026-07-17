import Foundation
import MacMagazineLibrary
import NetworkLibrary
import StorageLibrary
import SwiftData

@MainActor @Observable
public class FeedViewModel {
    public var status: Status = .idle

    public enum Status: Equatable {
        case idle
        case loading
        case done
        case error(reason: String)

        var reason: String? {
            switch self {
            case let .error(reason):
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
        guard status != .loading else { return }
        status = .loading
        do {
            try await Task {
                async let highlights = self.fetch(category: .highlights, page: page)
                async let appletv = self.fetch(category: .appletv, page: page)
                async let reviews = self.fetch(category: .reviews, page: page)
                async let tutoriais = self.fetch(category: .tutorials, page: page)
                async let rumors = self.fetch(category: .rumors, page: page)
                async let news = self.fetch(category: .news, page: page)

                let groups: [(category: NewsCategory, posts: [FeedDB])] = [
                    (.highlights, try await highlights.toFeedDB),
                    (.appletv, try await appletv.toFeedDB),
                    (.reviews, try await reviews.toFeedDB),
                    (.tutorials, try await tutoriais.toFeedDB),
                    (.rumors, try await rumors.toFeedDB),
                    (.news, try await news.toFeedDB)
                ]
                self.storage.save(feed: groups)
            }.value
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
        guard status != .loading else { return }
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

// MARK: - Search (returns transient results without saving to SwiftData)

extension FeedViewModel {
    public func search(term: String, page: Int = 0) async throws -> (feed: [FeedDB], podcasts: [PodcastDB]) {
        let data = try await networkService.search(term: term, page: page)
        let posts: [XMLPost] = try await withCheckedThrowingContinuation { continuation in
            Self.parse(
                data,
                category: "",
                numberOfPosts: -1,
                parseFullContent: false,
                continuation: continuation
            )
        }
        let podcastPosts = posts.filter { !$0.podcastURL.isEmpty }
        let feedPosts = posts.filter { $0.podcastURL.isEmpty }
        return (feed: feedPosts.toFeedDB, podcasts: podcastPosts.toPodcastDB)
    }
}

extension FeedViewModel {
    private func fetch(
        category: NewsCategory,
        page: Int,
        parseFullContent: Bool = false
    ) async throws -> [XMLPost] {
        do {
            let data = try await networkService.fetch(category: category, page: page)
            return try await withCheckedThrowingContinuation { continuation in
                Self.parse(
                    data,
                    category: category.filterKey,
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
