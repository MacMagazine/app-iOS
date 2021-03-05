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

    var cancellables = Set<AnyCancellable>()
    var selectedProduct: Product?

    var status: ((InAppPurchaseStatus) -> Void)?

    // MARK: - Methods -

    func checkSubscriptions() {
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

        InAppPurchase.shared.validateReceipt()
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

        InAppPurchase.shared.getProducts(for: ["MMASSINATURAMENSAL"])
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
