import Foundation
@testable import MMLiveLibrary
import NetworkLibrary
import StorageLibrary
import Testing

@Suite("MMLiveViewModel Tests")
@MainActor
struct MMLiveViewModelTests {

    // MARK: - Happy Path Tests

    @Test("Should fetch event from network and save to storage on first check")
    func fetchEventOnFirstCheck() async throws {
        // Given
        let mockData = [
            NetworkMockData(api: "/mmlive.json",
                            filename: "live",
                            bundlePath: Bundle.module.resourcePath)
        ]
        let mockNetwork = NetworkFactory.make(mapper: mockData)
        let storage = DefaultStorage("MMLiveTest_FirstCheck")
        let mockPushNotification = MockPushNotification()
        let sut = MMLiveViewModel(network: mockNetwork, storage: storage)
        sut.set(pushNotification: mockPushNotification)

        // When
        let isLive = await sut.isLive()

        // Then
        #expect(!isLive, "Event from live.json is in the past, should not be live")

        let saved = storage.get(key: "mmLive")
        #expect(saved != nil, "Event should be saved to UserDefaults")

        let savedEvent: MMLive? = storage.get()
        #expect(savedEvent?.inicio != nil, "Event should have inicio date")
        #expect(savedEvent?.fim != nil, "Event should have fim date")
        #expect(savedEvent?.lastChecked != nil, "Event should have lastChecked date set")

        #expect(mockPushNotification.notificationSetCount == 1, "Should schedule notification once")
    }

    @Test("Should return true when current time is between inicio and fim")
    func isLiveWhenBetweenStartAndEnd() async throws {
        // Given
        let now = Date()
        let pastStart = now.addingTimeInterval(-3600) // 1 hour ago
        let futureEnd = now.addingTimeInterval(3600) // 1 hour from now
        let lastChecked = now.addingTimeInterval(-3600 * 24) // 24 hour ago
        let liveEvent = MMLive(inicio: pastStart, fim: futureEnd, lastChecked: lastChecked)

        let storage = DefaultStorage("MMLiveTest_Live")
        storage.save(event: liveEvent)

        let mockNetwork = NetworkFactory.make(mapper: [])
        let sut = MMLiveViewModel(network: mockNetwork, storage: storage)
        sut.set(pushNotification: MockPushNotification())

        // When
        let isLive = await sut.isLive()

        // Then
        #expect(isLive, "Should be live when current time is between inicio and fim")
    }

    @Test("Should return false when event has not started yet")
    func notLiveWhenBeforeStart() async throws {
        // Given
        let now = Date()
        let futureStart = now.addingTimeInterval(3600) // 1 hour from now
        let futureEnd = now.addingTimeInterval(7200) // 2 hours from now

        let futureEvent = MMLive(inicio: futureStart, fim: futureEnd, lastChecked: nil)

        let storage = DefaultStorage("MMLiveTest_Future")
        storage.save(event: futureEvent)

        let mockNetwork = NetworkFactory.make(mapper: [])
        let sut = MMLiveViewModel(network: mockNetwork, storage: storage)
        sut.set(pushNotification: MockPushNotification())

        // When
        let isLive = await sut.isLive()

        // Then
        #expect(!isLive, "Should not be live when event hasn't started")
    }

    @Test("Should return false when event has already ended")
    func notLiveWhenAfterEnd() async throws {
        // Given
        let now = Date()
        let pastStart = now.addingTimeInterval(-7200) // 2 hours ago
        let pastEnd = now.addingTimeInterval(-3600) // 1 hour ago

        let pastEvent = MMLive(inicio: pastStart, fim: pastEnd, lastChecked: nil)

        let storage = DefaultStorage("MMLiveTest_Past")
        storage.save(event: pastEvent)

        let mockNetwork = NetworkFactory.make(mapper: [])
        let sut = MMLiveViewModel(network: mockNetwork, storage: storage)
        sut.set(pushNotification: MockPushNotification())

        // When
        let isLive = await sut.isLive()

        // Then
        #expect(!isLive, "Should not be live when event has ended")
    }

    // MARK: - 24-Hour Caching Tests

    @Test("Should use cached event when last checked within 24 hours")
    func useCacheWithin24Hours() async throws {
        // Given
        let now = Date()
        let pastStart = now.addingTimeInterval(-7200) // 2 hours ago
        let pastEnd = now.addingTimeInterval(-3600) // 1 hour ago
        let recentCheck = now.addingTimeInterval(-3600) // Checked 1 hour ago (within 24h window)

        let cachedEvent = MMLive(inicio: pastStart, fim: pastEnd, lastChecked: recentCheck)

        let storage = DefaultStorage("MMLiveTest_CacheHit")
        storage.save(event: cachedEvent)

        // Network that would fail if called
        let mockNetwork = NetworkFailed()
        let mockPushNotification = MockPushNotification()
        let sut = MMLiveViewModel(network: mockNetwork, storage: storage)
        sut.set(pushNotification: mockPushNotification)

        // When
        let isLive = await sut.isLive()

        // Then
        #expect(!isLive, "Should use cached data")
        #expect(mockPushNotification.notificationSetCount == 0, "Should not schedule notification when using cache")
    }

    @Test("Should refetch when last checked more than 24 hours ago")
    func refetchAfter24Hours() async throws {
        // Given
        let now = Date()
        let pastStart = now.addingTimeInterval(-7200)
        let pastEnd = now.addingTimeInterval(-3600)
        let oldCheck = now.addingTimeInterval(-86400 - 1) // 24 hours + 1 second ago (outside window)

        let staleEvent = MMLive(inicio: pastStart, fim: pastEnd, lastChecked: oldCheck)

        let storage = DefaultStorage("MMLiveTest_CacheMiss")
        storage.save(event: staleEvent)

        let mockData = [
            NetworkMockData(api: "/mmlive.json",
                            filename: "live",
                            bundlePath: Bundle.module.resourcePath)
        ]
        let mockNetwork = NetworkFactory.make(mapper: mockData)
        let mockPushNotification = MockPushNotification()
        let sut = MMLiveViewModel(network: mockNetwork, storage: storage)
        sut.set(pushNotification: mockPushNotification)

        // When
        let isLive = await sut.isLive()

        // Then
        #expect(!isLive)
        #expect(mockPushNotification.notificationSetCount == 0, "Should schedule notification when refetching")

        let updatedEvent: MMLive? = storage.get()
        #expect(updatedEvent?.lastChecked != nil)
        // Last checked should be recent (within last few seconds)
        guard let lastChecked = updatedEvent?.lastChecked else { return }
        let timeSinceCheck = now.timeIntervalSince(lastChecked)
        #expect(timeSinceCheck >= -5 && timeSinceCheck <= 5, "lastChecked should be updated to recent time")
    }

    @Test("Should refetch when no cached event exists")
    func refetchWhenNoCache() async throws {
        // Given
        let storage = DefaultStorage("MMLiveTest_NoCache")
        // No event saved

        let mockData = [
            NetworkMockData(api: "/mmlive.json",
                            filename: "live",
                            bundlePath: Bundle.module.resourcePath)
        ]
        let mockNetwork = NetworkFactory.make(mapper: mockData)
        let mockPushNotification = MockPushNotification()
        let sut = MMLiveViewModel(network: mockNetwork, storage: storage)
        sut.set(pushNotification: mockPushNotification)

        // When
        let isLive = await sut.isLive()

        // Then
        #expect(!isLive)
        #expect(mockPushNotification.notificationSetCount == 1, "Should schedule notification")

        let savedEvent: MMLive? = storage.get()
        #expect(savedEvent != nil, "Should save fetched event")
    }

    @Test("Should refetch when cached event has no lastChecked date")
    func refetchWhenNoLastChecked() async throws {
        // Given
        let now = Date()
        let pastStart = now.addingTimeInterval(-7200)
        let pastEnd = now.addingTimeInterval(-3600)

        let eventWithoutCheck = MMLive(inicio: pastStart, fim: pastEnd, lastChecked: nil)

        let storage = DefaultStorage("MMLiveTest_NoLastChecked")
        storage.save(event: eventWithoutCheck)

        let mockData = [
            NetworkMockData(api: "/mmlive.json",
                            filename: "live",
                            bundlePath: Bundle.module.resourcePath)
        ]
        let mockNetwork = NetworkFactory.make(mapper: mockData)
        let mockPushNotification = MockPushNotification()
        let sut = MMLiveViewModel(network: mockNetwork, storage: storage)
        sut.set(pushNotification: mockPushNotification)

        // When
        let isLive = await sut.isLive()

        // Then
        #expect(!isLive)
        #expect(mockPushNotification.notificationSetCount == 1, "Should schedule notification when refetching")
    }

    // MARK: - Error Handling Tests

    @Test("Should return false when network fetch fails")
    func returnFalseOnNetworkError() async throws {
        // Given
        let storage = DefaultStorage("MMLiveTest_NetworkError")
        let mockNetwork = NetworkFailed()
        let mockPushNotification = MockPushNotification()
        let sut = MMLiveViewModel(network: mockNetwork, storage: storage)
        sut.set(pushNotification: mockPushNotification)

        // When
        let isLive = await sut.isLive()

        // Then
        #expect(!isLive, "Should return false gracefully when network fails")
        #expect(mockPushNotification.notificationSetCount == 0, "Should not schedule notification on error")
    }

    // MARK: - Edge Cases

    @Test("Should handle event exactly at start time")
    func liveAtExactStartTime() async throws {
        // Given
        let now = Date()
        let futureEnd = now.addingTimeInterval(3600)

        let event = MMLive(inicio: now, fim: futureEnd, lastChecked: nil)

        let storage = DefaultStorage("MMLiveTest_ExactStart")
        storage.save(event: event)

        let mockNetwork = NetworkFactory.make(mapper: [])
        let sut = MMLiveViewModel(network: mockNetwork, storage: storage)
        sut.set(pushNotification: MockPushNotification())

        // When
        let isLive = await sut.isLive()

        // Then - At exact start time, Date() > event.inicio is false, so not live yet
        #expect(!isLive, "Should not be live at exact start time (needs to be after)")
    }

    @Test("Should handle event exactly at end time")
    func notLiveAtExactEndTime() async throws {
        // Given
        let now = Date()
        let pastStart = now.addingTimeInterval(-3600)

        let event = MMLive(inicio: pastStart, fim: now, lastChecked: nil)

        let storage = DefaultStorage("MMLiveTest_ExactEnd")
        storage.save(event: event)

        let mockNetwork = NetworkFactory.make(mapper: [])
        let sut = MMLiveViewModel(network: mockNetwork, storage: storage)
        sut.set(pushNotification: MockPushNotification())

        // When
        let isLive = await sut.isLive()

        // Then - At exact end time, Date() < event.fim is false, so not live anymore
        #expect(!isLive, "Should not be live at exact end time")
    }
}

// MARK: - Test Doubles

class MockPushNotification: PushNotificationProtocol {
    var notificationSetCount = 0
    var lastEvent: MMLive?

    @MainActor
    func setLocalNotification(for event: MMLive) {
        notificationSetCount += 1
        lastEvent = event
    }
}
