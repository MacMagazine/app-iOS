import AnalyticsLibrary
import Foundation
import InAppLibrary
import MacMagazineLibrary
import StorageLibrary
import UIKit

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
            case .purchasable(let products):
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

    let inAppLibrary = InAppManager()
    private var observationTask: Task<Void, Never>?

    init() {
        setupListeners()
    }

    func setupListeners() {
        observationTask = Task { @MainActor [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                let currentStatus = withObservationTracking {
                    self.inAppLibrary.status
                } onChange: {
                    // This closure is called when status changes
                }

                self.process(purchased: currentStatus)

                // Small delay to prevent tight loop
                try? await Task.sleep(for: .milliseconds(100))
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
                let products = try await inAppLibrary.getProducts(for: ["MMASSINATURAMENSAL_BETA", "MMASSINATURAANUAL_BETA"])
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
    func process(purchased: InAppStatus) {
        switch purchased {
        case let .purchased(identifier):
            if let transaction = status.product(using: identifier) {
                Task {
                    analytics?.track(
                        .purchaseCompleted(productId: identifier,
                                           revenue: transaction.price)
                    )

                    await change(expirationDate: transaction.expirationDate)
                    isValidSubscription = storage?.settings?.subscription.isValidSubscription ?? false
                }
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
