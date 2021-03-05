//
//  Subscriptions.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 05/03/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import Combine
import Foundation
import InAppPurchase

enum InAppPurchaseStatus {
    case canPurchase
    case processing
    case gotProductPrice(String)
    case purchasedSuccess
    case fail
}

class Subscriptions {

    static let shared = Subscriptions()

    let identifier = "MMASSINATURAMENSAL"

    var cancellables = Set<AnyCancellable>()
    var selectedProduct: Product?

    var status: ((InAppPurchaseStatus) -> Void)?

    // MARK: - Methods -

    func checkSubscriptions() {
        cancellables.forEach { $0.cancel() }

        InAppPurchaseManager.shared.$error
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { _ in
                var settings = Settings()
                settings.purchased = false
            }
            .store(in: &cancellables)

        InAppPurchaseManager.shared.$status
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink {
                var settings = Settings()
                settings.purchased = $0 == .validationSuccess
            }
            .store(in: &cancellables)

        InAppPurchaseManager.shared.validateReceipt(subscription: identifier)
    }

    func getProducts() {
        if InAppPurchaseManager.shared.canPurchase {
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

        InAppPurchaseManager.shared.$error
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { _ in
                self.status?(.fail)
            }
            .store(in: &cancellables)

        InAppPurchaseManager.shared.$success
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

        InAppPurchaseManager.shared.buy(product: product)
    }

    func recover() {
        cancellables.forEach { $0.cancel() }

        status?(.processing)

        InAppPurchaseManager.shared.$error
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { _ in
                self.status?(.fail)
            }
            .store(in: &cancellables)

        InAppPurchaseManager.shared.$success
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

        InAppPurchaseManager.shared.restore()
    }

}

extension Subscriptions {
    fileprivate func fetchProductInformation() {
        cancellables.forEach { $0.cancel() }

        status?(.processing)

        InAppPurchaseManager.shared.$error
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { _ in
                self.status?(.fail)
            }
            .store(in: &cancellables)

        InAppPurchaseManager.shared.$products
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

        InAppPurchaseManager.shared.getProducts(for: [identifier])
    }
}
