import Combine
import Foundation
import StoreKit

class RestoreManager: NSObject, ObservableObject {

    static let shared = RestoreManager()

    @Published var success: Bool?
    @Published var error: Error?

    override init() {
        super.init()

        SKPaymentQueue.default().add(self)
    }

    func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: - SKPaymentTransactionObserver -

extension RestoreManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
                case .purchasing, .purchased: break
                case .deferred, .failed: failed(transaction)
                case .restored: restored(transaction)
                @unknown default: fatalError("unknownPaymentTransaction")
            }
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        if (error as? SKError)?.code != .paymentCancelled {
            self.error = error
        }
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        SKPaymentQueue.default().remove(self)
    }
}

// MARK: -

extension RestoreManager {
    fileprivate func restored(_ transaction: SKPaymentTransaction) {
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
