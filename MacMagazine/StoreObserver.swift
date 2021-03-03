import Foundation
import StoreKit

// MARK: - Message -

/// A structure of messages that will be displayed to users.
struct Messages {
    static let cannotMakePayments = "\(notAuthorized) \(installing)"
    static let couldNotFind = "Could not find resource file:"
    static let deferred = "Allow the user to continue using your app."
    static let deliverContent = "Deliver content for"
    static let emptyString = ""
    static let error = "Error: "
    static let failed = "failed."
    static let installing = "In-App Purchases may be restricted on your device."
    static let invalidIndexPath = "Invalid selected index path"
    static let noRestorablePurchases = "There are no restorable purchases.\n\(previouslyBought)"
    static let noPurchasesAvailable = "No purchases available."
    static let notAuthorized = "You are not authorized to make payments."
    static let okButton = "OK"
    static let previouslyBought = "Only previously bought non-consumable products and auto-renewable subscriptions can be restored."
    static let productRequestStatus = "Product Request Status"
    static let purchaseOf = "Purchase of"
    static let purchaseStatus = "Purchase Status"
    static let removed = "was removed from the payment queue."
    static let restorable = "All restorable transactions have been processed by the payment queue."
    static let restoreContent = "Restore content for"
    static let status = "Status"
    static let unableToInstantiateAvailableProducts = "Unable to instantiate an AvailableProducts."
    static let unableToInstantiateInvalidProductIds = "Unable to instantiate an InvalidProductIdentifiers."
    static let unableToInstantiateMessages = "Unable to instantiate a MessagesViewController."
    static let unableToInstantiateNavigationController = "Unable to instantiate a navigation controller."
    static let unableToInstantiateProducts = "Unable to instantiate a Products."
    static let unableToInstantiatePurchases = "Unable to instantiate a Purchases."
    static let unableToInstantiateSettings = "Unable to instantiate a Settings."
    static let unknownPaymentTransaction = "Unknown payment transaction case."
    static let unknownDestinationViewController = "Unknown destination view controller."
    static let unknownDetail = "Unknown detail row:"
    static let unknownPurchase = "No selected purchase."
    static let unknownSelectedSegmentIndex = "Unknown selected segment index: "
    static let unknownSelectedViewController = "Unknown selected view controller."
    static let unknownTabBarIndex = "Unknown tab bar index:"
    static let unknownToolbarItem = "Unknown selected toolbar item: "
    static let updateResource = "Update it with your product identifiers to retrieve product information."
    static let useStoreRestore = "Use Store > Restore to restore your previously bought non-consumable products and auto-renewable subscriptions."
    static let viewControllerDoesNotExist = "The main content view controller does not exist."
    static let windowDoesNotExist = "The window does not exist."
}

class StoreObserver: NSObject {

    static let shared = StoreObserver()

    // MARK: - Properties -

    var isAuthorizedForPayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }

    var purchased = [SKPaymentTransaction]()

    var restored = [SKPaymentTransaction]()
    fileprivate var hasRestorablePurchases = false

    weak var delegate: StoreObserverDelegate?

    // MARK: - Initializer -

    private override init() {}

    // MARK: - Submit Payment Request -

    func buy(_ product: SKProduct) {
        let payment = SKMutablePayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    // MARK: - Restore All Restorable Purchases -

    func restore() {
        if !restored.isEmpty {
            restored.removeAll()
        }
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    // MARK: - Handle Payment Transactions -

    fileprivate func handlePurchased(_ transaction: SKPaymentTransaction) {
        purchased.append(transaction)
print("\(Messages.deliverContent) \(transaction.payment.productIdentifier).")

        SKPaymentQueue.default().finishTransaction(transaction)
    }

    fileprivate func handleFailed(_ transaction: SKPaymentTransaction) {
        var message = "\(Messages.purchaseOf) \(transaction.payment.productIdentifier) \(Messages.failed)"

        if let error = transaction.error {
            message += "\n\(Messages.error) \(error.localizedDescription)"
print("\(Messages.error) \(error.localizedDescription)")
        }

        // Do not send any notifications when the user cancels the purchase.
        if (transaction.error as? SKError)?.code != .paymentCancelled {
            DispatchQueue.main.async {
                self.delegate?.storeObserverDidReceiveMessage(message)
            }
        }
        // Finish the failed transaction.
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    /// Handles restored purchase transactions.
    fileprivate func handleRestored(_ transaction: SKPaymentTransaction) {
        hasRestorablePurchases = true
        restored.append(transaction)
print("\(Messages.restoreContent) \(transaction.payment.productIdentifier).")

        DispatchQueue.main.async {
            self.delegate?.storeObserverRestoreDidSucceed()
        }
        // Finishes the restored transaction.
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}

// MARK: - SKPaymentTransactionObserver -

extension StoreObserver: SKPaymentTransactionObserver {

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing: break
            // Do not block the UI. Allow the user to continue using the app.
            case .deferred: print(Messages.deferred)
            // The purchase was successful.
            case .purchased: handlePurchased(transaction)
            // The transaction failed.
            case .failed: handleFailed(transaction)
            // There're restored products.
            case .restored: handleRestored(transaction)
            @unknown default: fatalError(Messages.unknownPaymentTransaction)
            }
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
print("\(transaction.payment.productIdentifier) \(Messages.removed)")
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        if let error = error as? SKError, error.code != .paymentCancelled {
            DispatchQueue.main.async {
                self.delegate?.storeObserverDidReceiveMessage(error.localizedDescription)
            }
        }
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
print(Messages.restorable)

        if !hasRestorablePurchases {
            DispatchQueue.main.async {
                self.delegate?.storeObserverDidReceiveMessage(Messages.noRestorablePurchases)
            }
        }
    }
}
