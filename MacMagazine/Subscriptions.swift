//
//  Subscriptions.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 05/03/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import Combine
import Foundation

enum InAppPurchaseStatus {
    case canPurchase
    case processing
    case gotProductPrice(String)
    case purchasedSuccess
    case fail
}

#if canImport(InAppPurchase)
import InAppPurchase

class Subscriptions {

    static let shared = Subscriptions()

    let identifier = "MMASSINATURAMENSAL"

    var cancellables = Set<AnyCancellable>()
    var selectedProduct: Product?

    var status: ((InAppPurchaseStatus) -> Void)?

    // MARK: - Methods -

    func checkSubscriptions() {
        cancellables.forEach { $0.cancel() }

        InAppPurchase.shared.$error
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { _ in
                var settings = Settings()
                settings.purchased = false
            }
            .store(in: &cancellables)

        InAppPurchase.shared.$status
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink {
                var settings = Settings()
                settings.purchased = $0 == .validationSuccess
            }
            .store(in: &cancellables)

        InAppPurchase.shared.validateReceipt(subscription: identifier)
    }

    func getProducts() {
        if InAppPurchase.shared.canPurchase {
            if Settings().purchased {
                status?(.purchasedSuccess)
            } else {
                status?(.canPurchase)
                fetchProductInformation()
            }
        }
    }

    func buy() {
        cancellables.forEach { $0.cancel() }

        guard let product = selectedProduct else {
            return
        }

        status?(.processing)

        InAppPurchase.shared.$error
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { _ in
                self.status?(.fail)
            }
            .store(in: &cancellables)

        InAppPurchase.shared.$success
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink {
                if $0 {
                    self.status?(.purchasedSuccess)
                } else {
                    self.status?(.fail)
                }
            }
            .store(in: &cancellables)

        InAppPurchase.shared.buy(product: product)
    }

    func recover() {
        cancellables.forEach { $0.cancel() }

        status?(.processing)

        InAppPurchase.shared.$error
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { _ in
                self.status?(.fail)
            }
            .store(in: &cancellables)

        InAppPurchase.shared.$success
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink {
                if $0 {
                    self.status?(.purchasedSuccess)
                } else {
                    self.status?(.fail)
                }
            }
            .store(in: &cancellables)

        InAppPurchase.shared.restore()
    }

}

extension Subscriptions {
    fileprivate func fetchProductInformation() {
        cancellables.forEach { $0.cancel() }

        status?(.processing)

        InAppPurchase.shared.$error
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { _ in
                self.status?(.fail)
            }
            .store(in: &cancellables)

        InAppPurchase.shared.$products
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink {
                guard let product = $0.first,
                      let price = product.price else {
                    self.status?(.fail)
                    return
                }
                self.selectedProduct = product
                self.status?(.gotProductPrice(price))
            }
            .store(in: &cancellables)

        InAppPurchase.shared.getProducts(for: [identifier])
    }
}

#else

class Subscriptions {

    static let shared = Subscriptions()

    var status: ((InAppPurchaseStatus) -> Void)?

    func checkSubscriptions() {
        var settings = Settings()
        settings.purchased = false
    }

    func getProducts() {}
    func buy() {}
    func recover() {}
}

#endif
