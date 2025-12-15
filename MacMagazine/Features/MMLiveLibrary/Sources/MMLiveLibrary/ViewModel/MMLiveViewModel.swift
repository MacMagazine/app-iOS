import Combine
import Foundation
import NetworkLibrary
import StorageLibrary

@MainActor
public class MMLiveViewModel {
    let storage: Storage
    let networkService: NetworkService
    let hours24: TimeInterval = 86400 // 24 hours

    var pushNotification: PushNotificationProtocol?

    public init(
        network: Network? = nil,
        storage: Storage? = nil,
    ) {
        self.storage = storage ?? DefaultStorage("MMLive")
        self.networkService = NetworkService(network: network)
        self.pushNotification = PushNotification()
    }

    public func isLive() async -> Bool {
        guard let event = storage.get(),
              let lastChecked = event.lastChecked,
              Date() > lastChecked.addingTimeInterval(hours24) else {
            guard let event = try? await fetch() else { return false }
            pushNotification?.setLocalNotification(for: event)
            return isLive(event: event)
        }
        return isLive(event: event)
    }

    func set(pushNotification: PushNotificationProtocol) {
        self.pushNotification = pushNotification
    }
}

private extension MMLiveViewModel {
    func isLive(event: MMLive) -> Bool {
        var event = event
        event.lastChecked = Date()
        storage.save(event: event)
        return true // Date() > event.inicio && Date() < event.fim
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
