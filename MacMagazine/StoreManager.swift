import Foundation
import StoreKit

class StoreManager: NSObject {
    // MARK: - Types

    static let shared = StoreManager()

    // MARK: - Properties

    /// Keeps track of all valid products. These products are available for sale in the App Store.
    fileprivate var availableProducts = [SKProduct]()

    /// Keeps track of all invalid product identifiers.
    fileprivate var invalidProductIdentifiers = [String]()

    /// Keeps a strong reference to the product request.
    fileprivate var productRequest: SKProductsRequest?

    /// Keeps track of all valid products (these products are available for sale in the App Store) and of all invalid product identifiers.
    fileprivate var storeResponse = [Section]()

    weak var delegate: StoreManagerDelegate?

    // MARK: - Initializer

    private override init() {}

    // MARK: - Request Product Information

    /// Starts the product request with the specified identifiers.
    func startProductRequest(with identifiers: [String]) {
        // Initialize the product request with the above identifiers.
        productRequest = SKProductsRequest(productIdentifiers: Set(identifiers))
        productRequest?.delegate = self

        // Send the request to the App Store.
        productRequest?.start()
    }
}

// MARK: - SKProductsRequestDelegate -

/// Extends StoreManager to conform to SKProductsRequestDelegate.
extension StoreManager: SKProductsRequestDelegate {
    /// Used to get the App Store's response to your request and notify your observer.
    /// - Tag: ProductRequest
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if !storeResponse.isEmpty {
            storeResponse.removeAll()
        }

        // products contains products whose identifiers have been recognized by the App Store. As such, they can be purchased.
        if !response.products.isEmpty {
            availableProducts = response.products
        }

        // invalidProductIdentifiers contains all product identifiers not recognized by the App Store.
        if !response.invalidProductIdentifiers.isEmpty {
            invalidProductIdentifiers = response.invalidProductIdentifiers
        }

        if !availableProducts.isEmpty {
            storeResponse.append(Section(type: .availableProducts, elements: availableProducts))
        }

        if !invalidProductIdentifiers.isEmpty {
            storeResponse.append(Section(type: .invalidProductIdentifiers, elements: invalidProductIdentifiers))
        }

        if !storeResponse.isEmpty {
            DispatchQueue.main.async {
                self.delegate?.storeManagerDidReceiveResponse(self.storeResponse)
            }
        }
    }
}

// MARK: - SKRequestDelegate -

/// Extends StoreManager to conform to SKRequestDelegate.
extension StoreManager: SKRequestDelegate {
    /// Called when the product request failed.
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.delegate?.storeManagerDidReceiveMessage(error.localizedDescription)
        }
    }
}
