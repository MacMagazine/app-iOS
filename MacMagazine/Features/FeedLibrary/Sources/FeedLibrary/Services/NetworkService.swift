import Foundation
import MacMagazineLibrary
import NetworkLibrary

final class NetworkService: Sendable {
    private nonisolated(unsafe) let network: Network

    init(network: Network? = nil) {
        self.network = network ?? NetworkFactory.make()
    }
}

extension NetworkService {
    func fetch(category: NewsCategory, page: Int) async throws -> Data {
        do {
            let endpoint = Endpoint.posts(paged: page, query: category.query)
            return try await network.get(url: endpoint.url, headers: [:])
        } catch {
            throw error
        }
    }
}
