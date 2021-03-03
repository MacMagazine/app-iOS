import Foundation
import StoreKit

class ProductManager: NSObject, ObservableObject {

    static let shared = ProductManager()

    fileprivate var productRequest: SKProductsRequest?

    @Published var products: [SKProduct]?
    @Published var error: Error?

    func startProductRequest(with identifiers: [String]) {
        productRequest = SKProductsRequest(productIdentifiers: Set(identifiers))
        productRequest?.delegate = self
        productRequest?.start()
    }

}

// MARK: - SKProductsRequestDelegate -

extension ProductManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if !response.products.isEmpty {
            products = response.products
        }
    }
}

// MARK: - SKRequestDelegate -

extension ProductManager: SKRequestDelegate {
    func request(_ request: SKRequest, didFailWithError error: Error) {
        self.error = error
    }
}

// MARK: - SKProduct Extension -

extension SKProduct {
    var localizedPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)
    }

    var subscription: String? {
        guard let number = self.subscriptionPeriod?.numberOfUnits,
              let unit = self.subscriptionPeriod?.unit else {
            return nil
        }
        return "\(number) \(unit)"
    }
}
