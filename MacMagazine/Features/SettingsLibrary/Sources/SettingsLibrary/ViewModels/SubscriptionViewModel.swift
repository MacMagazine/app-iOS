import AnalyticsLibrary
import Foundation
import InAppLibrary
import MacMagazineLibrary
import os
import StorageLibrary
import UIKit

private let logger = Logger(subsystem: "com.macmagazine", category: "Subscription")

@MainActor
@Observable
final class SubscriptionViewModel {
    enum Status {
        case idle
        case loading
        case purchasable(products: [InAppProduct])
        case error(reason: String)

        func product(using identifier: String) -> InAppProduct? {
            switch self {
            case let .purchasable(products):
                products.first(where: { $0.identifier == identifier })
            default: nil
            }
        }
    }

    var isPatrao = false
    var isValidSubscription = false
    var status: Status = .idle
    var storage: Database?
    var analytics: AnalyticsManager?

    let inAppLibrary: InAppManager
    private var observationTask: Task<Void, Never>?

    init(inAppLibrary: InAppManager = InAppManager()) {
        self.inAppLibrary = inAppLibrary
        setupListeners()
    }

    func setupListeners() {
        observationTask = Task { @MainActor [weak self] in
            while !Task.isCancelled {
                guard let self else { return }
                await withCheckedContinuation { continuation in
                    withObservationTracking {
                        _ = self.inAppLibrary.status
                    } onChange: {
                        continuation.resume()
                    }
                }
                guard !Task.isCancelled else { return }
                await self.process(purchased: self.inAppLibrary.status)
            }
        }
    }
}

extension SubscriptionViewModel {
    func get() async {
        isValidSubscription = storage?.settings?.subscription.isValidSubscription ?? false
        isPatrao = storage?.settings?.subscription.isPatrao ?? false

        if !isValidSubscription {
            await change(isPatrao: false)
        }
    }

    func change(isPatrao: Bool) async {
        storage?.update(isPatrao: isPatrao)
    }

    func change(expirationDate: Date) async {
        storage?.update(expirationDate: expirationDate)
    }
}

extension SubscriptionViewModel {
    func getPurchasableProducts() async throws {
        if inAppLibrary.canPurchase {
            do {
                status = .loading
                let products = try await inAppLibrary.getProducts(for: ["MMASSINATURAMENSAL", "MMASSINATURAANUAL"])
                status = .purchasable(products: products)
            } catch {
                status = .error(reason: error.localizedDescription)
            }
        }
    }

    func restore() {
        Task {
            await inAppLibrary.restore()
        }
    }

    func purchase(
        using identifier: String,
        analytics: AnalyticsManager
    ) {
        guard let product = status.product(using: identifier) else { return }
        self.analytics = analytics

        Task {
            await inAppLibrary.purchase(product)

            analytics.track(
                .purchaseInitiated(productId: identifier, price: product.price)
            )
        }
    }
}

private extension SubscriptionViewModel {
    func process(purchased: InAppStatus) async {
        logger.debug("[process] InApp status: \(String(describing: purchased))")

        switch purchased {
        case let .purchased(identifier):
            logger.debug("[process] .purchased identifier: \(identifier)")
            logger.debug("[process] ViewModel status: \(String(describing: self.status))")

            if let transaction = status.product(using: identifier) {
                logger.debug("[process] Found product, expirationDate: \(transaction.expirationDate)")
                analytics?.track(
                    .purchaseCompleted(productId: identifier,
                                       revenue: transaction.price)
                )
                await change(expirationDate: transaction.expirationDate)
                isValidSubscription = storage?.settings?.subscription.isValidSubscription ?? false
                logger.debug("[process] isValidSubscription: \(self.isValidSubscription)")
                logger.debug("[process] storage removeAds: \(self.storage?.settings?.subscription.removeAds ?? false)")
            } else {
                logger.error("[process] FAILED: status.product(using: \(identifier)) returned nil")
            }

        case .cancelled:
            analytics?.track(.purchaseCancelled)

        case let .error(reason):
            analytics?.track(
                .error(code: "", message: reason.localizedDescription, screen: AnalyticsConstants.Screen.settings.name)
            )
        case .pending:
            analytics?.track(.purchasePending)

        default: break
        }
        inAppLibrary.status = .unknown
    }
}
