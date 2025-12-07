@preconcurrency import Combine
import Foundation
import InAppLibrary
import StorageLibrary
import UIKit

@MainActor
final class SubscriptionViewModel: ObservableObject {
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

    @Published var isPatrao = false
    @Published var isValidSubscription = false
    @Published var status: Status = .idle

    var storage: Database?

    let inAppLibrary = InAppManager()
    var cancellables: Set<AnyCancellable> = []

    init() {
        setupListeners()
    }

    func setupListeners() {
        Task {
            let statusPublisher = await inAppLibrary.$status
            statusPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] status in
                    self?.process(purchased: status)
                }
                .store(in: &cancellables)
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
        if await inAppLibrary.canPurchase {
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
