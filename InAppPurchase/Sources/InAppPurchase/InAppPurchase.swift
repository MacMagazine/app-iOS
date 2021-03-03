import Combine
import StoreKit

public class InAppPurchase: ObservableObject {

    // MARK: - Singleton -

    static public let shared = InAppPurchase()

    // MARK: - General properties -

    public var canPurchase: Bool {
        return SKPaymentQueue.canMakePayments()
    }

    @Published public var error: Error?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Products -

    @Published public var products: [Product]?

    public func getProducts(for identifiers: [String]) {
        cancellables.forEach { $0.cancel() }

        ProductManager.shared.$products
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink {
                self.products = $0.map { value in
                    Product(title: value.localizedTitle,
                            description: value.localizedDescription,
                            price: value.localizedPrice,
                            identifier: value.productIdentifier,
                            subscription: value.subscription,
                            product: value)
                }
            }
            .store(in: &cancellables)

        ProductManager.shared.$error
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink {
                self.error = $0
            }
            .store(in: &cancellables)

        ProductManager.shared.startProductRequest(with: identifiers)
    }

    // MARK: - Purchase -

    @Published public var success: Bool?

    public func buy(product: Product) {
        cancellables.forEach { $0.cancel() }

        guard let skProduct = product.product else {
            return
        }

        PurchaseManager.shared.$success
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink {
                self.success = $0
            }
            .store(in: &cancellables)

        PurchaseManager.shared.$error
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink {
                self.error = $0
            }
            .store(in: &cancellables)

        PurchaseManager.shared.buy(product: skProduct)
    }

    // MARK: - Restore -

    // MARK: - Receipts -
}
