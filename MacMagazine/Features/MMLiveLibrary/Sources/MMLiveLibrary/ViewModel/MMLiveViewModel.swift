import Combine
import Foundation
import NetworkLibrary
import StorageLibrary

@MainActor
public class MMLiveViewModel {
    let storage: Storage
    let networkService: NetworkService

    public init(
        network: Network? = nil,
        storage: Storage? = nil
    ) {
        self.storage = storage ?? DefaultStorage("MMLive")
        self.networkService = NetworkService(network: network)
    }

    public func isLive() async -> Bool {
        guard let event = storage.get() else {
            guard let event = try? await fetch() else { return false }
            return isLive(event: event)
        }
        return isLive(event: event)
    }

}

private extension MMLiveViewModel {
    func isLive(event: MMLive) -> Bool {
        var event = event
        event.lastChecked = Date()
        storage.save(event: event)
        return Date() > event.inicio && Date() < event.fim
    }
}

private extension MMLiveViewModel {
    func fetch() async throws -> MMLive {
        do {
            let data = try await networkService.fetch()

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970

            return try decoder.decode(MMLive.self, from: data)

        } catch {
            throw error
        }
    }
}
