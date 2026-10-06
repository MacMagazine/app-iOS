import Foundation
import InAppLibrary
@testable import SettingsLibrary
import StorageLibrary
import Testing

@MainActor
final class FakeInAppManager: InAppManaging {
    var status: InAppStatus = .unknown
    var canPurchase = true
    var productsToReturn: [InAppProduct] = []
    var getProductsCallCount = 0
    var restoreCallCount = 0

    func getProducts(for identifiers: [String]) async throws -> [InAppProduct] {
        getProductsCallCount += 1
        return productsToReturn
    }

    func purchase(_ product: InAppProduct) async {}

    func restore() async {
        restoreCallCount += 1
    }
}

@Suite("SubscriptionViewModel Tests")
@MainActor
struct SubscriptionViewModelTests {

    private func makeProduct(identifier: String) -> InAppProduct {
        InAppProduct(title: "Title", description: "Description", price: "R$ 1,00", identifier: identifier, subscription: "")
    }

    // MARK: - get()

    @Test("get() does not write to storage when there is no subscription yet")
    func getDoesNotPersistWhenNotSubscribed() async {
        let storage = Database(models: [SettingsDB.self], inMemory: true)
        let sut = SubscriptionViewModel(inAppLibrary: FakeInAppManager())
        sut.storage = storage

        await sut.get()

        #expect(storage.settings == nil, "Reading the subscription state must not insert a new record")
    }

    @Test("get() does not overwrite an already-valid subscription")
    func getDoesNotOverwriteValidSubscription() async {
        let storage = Database(models: [SettingsDB.self], inMemory: true)
        let futureDate = Date().addingTimeInterval(86_400)
        storage.update(expirationDate: futureDate)
        let modifiedAtBeforeGet = storage.settings?.modifiedAt

        let sut = SubscriptionViewModel(inAppLibrary: FakeInAppManager())
        sut.storage = storage

        await sut.get()

        #expect(sut.isValidSubscription)
        #expect(storage.settings?.modifiedAt == modifiedAtBeforeGet, "get() must only read, never write")
    }

    // MARK: - process(purchased:)

    @Test("process(purchased:) resolves the product by fetching the catalog when it isn't loaded yet")
    func processFetchesCatalogWhenMissing() async {
        let storage = Database(models: [SettingsDB.self], inMemory: true)
        let fake = FakeInAppManager()
        fake.productsToReturn = [makeProduct(identifier: "MMASSINATURAMENSAL")]

        let sut = SubscriptionViewModel(inAppLibrary: fake)
        sut.storage = storage
        #expect(sut.status.product(using: "MMASSINATURAMENSAL") == nil, "Catalog starts unloaded")

        await sut.process(purchased: .purchased(identifier: "MMASSINATURAMENSAL"))

        #expect(fake.getProductsCallCount == 1, "A missing product must trigger a catalog fetch instead of being dropped")
        #expect(storage.settings != nil, "The entitlement must be persisted once the product is found")
    }

    @Test("process(purchased:) does not refetch the catalog when the product is already loaded")
    func processSkipsCatalogFetchWhenAlreadyLoaded() async {
        let storage = Database(models: [SettingsDB.self], inMemory: true)
        let fake = FakeInAppManager()
        let product = makeProduct(identifier: "MMASSINATURAANUAL")
        fake.productsToReturn = [product]

        let sut = SubscriptionViewModel(inAppLibrary: fake)
        sut.storage = storage
        sut.status = .purchasable(products: [product])

        await sut.process(purchased: .purchased(identifier: "MMASSINATURAANUAL"))

        #expect(fake.getProductsCallCount == 0)
        #expect(storage.settings != nil)
    }

    // MARK: - refreshEntitlements()

    @Test("refreshEntitlements() fetches the catalog and restores entitlements")
    func refreshEntitlementsFetchesAndRestores() async {
        let fake = FakeInAppManager()
        let sut = SubscriptionViewModel(inAppLibrary: fake)

        await sut.refreshEntitlements()

        #expect(fake.getProductsCallCount == 1)
        #expect(fake.restoreCallCount == 1)
    }
}
