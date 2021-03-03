import Combine
import Foundation
import StoreKit

class PurchaseManager: NSObject, ObservableObject {

    static let shared = PurchaseManager()

    @Published var success: Bool?
    @Published var error: Error?

    override init() {
        super.init()

        SKPaymentQueue.default().add(self)
    }

    func buy(product: SKProduct) {
        let payment = SKMutablePayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}

// MARK: - SKPaymentTransactionObserver -

extension PurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
                case .purchasing, .restored: break
                case .deferred, .failed: failed(transaction)
                case .purchased: purchased(transaction)
                @unknown default: fatalError("unknownPaymentTransaction")
            }
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        SKPaymentQueue.default().remove(self)
    }
}

// MARK: -

extension PurchaseManager {
    fileprivate func purchased(_ transaction: SKPaymentTransaction) {
        success = true
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    fileprivate func failed(_ transaction: SKPaymentTransaction) {
        // Do not send any notifications when the user cancels the purchase.
        if (transaction.error as? SKError)?.code != .paymentCancelled {
            error = transaction.error
        }

        SKPaymentQueue.default().finishTransaction(transaction)
    }

}
