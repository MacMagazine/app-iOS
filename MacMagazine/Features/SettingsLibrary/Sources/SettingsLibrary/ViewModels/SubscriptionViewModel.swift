import Foundation
import InAppLibrary
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

    func purchase(using identifier: String) {
        guard let product = status.product(using: identifier) else { return }
        Task {
            await inAppLibrary.purchase(product)
        }
    }
}

private extension SubscriptionViewModel {
    func process(purchased: InAppStatus) {
        if case .purchased(let identifier) = purchased,
           let expirationDate = status.product(using: identifier)?.expirationDate {
            Task {
                await change(expirationDate: expirationDate)
                isValidSubscription = storage?.settings?.subscription.isValidSubscription ?? false
            }
        }
    }
}
