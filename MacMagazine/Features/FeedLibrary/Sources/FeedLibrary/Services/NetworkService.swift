import Foundation
import NetworkLibrary

final class NetworkService: Sendable {
    private nonisolated(unsafe) let network: Network

    init(network: Network? = nil) {
        self.network = network ?? NetworkFactory.make()
    }
}

extension NetworkService {
    func fetch(category: Category) async throws -> Data {
        do {
            let endpoint = Endpoint.posts(paged: 0, query: category.query)
            return try await network.get(url: endpoint.url, headers: [:])
        } catch {
            throw error
        }
    }
}
