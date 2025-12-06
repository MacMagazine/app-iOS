import Foundation
import NetworkLibrary

final class NetworkService: Sendable {
    private nonisolated(unsafe) let network: Network

    init(network: Network? = nil) {
        self.network = network ?? NetworkFactory.make()
    }
}

extension NetworkService {
    func fetch() async throws -> Data {
        do {
            let endpoint = Endpoint.mmLive()
            return try await network.get(url: endpoint.url, headers: [:])
        } catch {
            throw error
        }
    }
}
