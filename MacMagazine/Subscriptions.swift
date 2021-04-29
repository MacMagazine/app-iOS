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
    case gotProduct(Product)
    case purchasedSuccess
    case expired
    case fail
    case disabled
}

class Subscriptions {

    static let shared = Subscriptions()

    let identifier = "MMASSINATURAMENSAL"

    var productCancellable: AnyCancellable?
    var purchaseCancellable: AnyCancellable?
    var receiptCancellable: AnyCancellable?

    var selectedProduct: Product?
    var status: ((InAppPurchaseStatus) -> Void)?
    var isPurchasing: Bool = false

    // MARK: - Methods -

    func checkSubscriptions(_ onCompletion: ((Bool) -> Void)? = nil) {
        productCancellable?.cancel()
        purchaseCancellable?.cancel()
        receiptCancellable?.cancel()

        var retry = 1

        receiptCancellable = InAppPurchaseManager.shared.$status
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] rsp in
                switch rsp {
                    case .failure(_):
                        onCompletion?(false)
                        self?.status?(.canPurchase)

                    case .success(let response):
                        switch response {
                        case .retrieving,
                             .purchasing,
                             .restoring,
                             .validating:
                            self?.status?(.processing)
                        case .validated:
                            onCompletion?(true)
                            self?.status?(.purchasedSuccess)
                        case .expired:
                            onCompletion?(false)
                            self?.status?(.expired)

                            retry -= 1
                            if retry == 0 {
                                // Try to self refresh receipt
                                guard let self = self else { return }
                                InAppPurchaseManager.shared.refreshReceipt(subscription: self.identifier)
                            }

                        default:
                            onCompletion?(false)
                            self?.status?(.canPurchase)
                        }
                }
            }

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
        } else {
            status?(.disabled)
        }
    }

    func purchase() {
        buy(restore: false)
    }

    func restore() {
        buy(restore: true)
    }

    fileprivate func buy(restore: Bool) {
        productCancellable?.cancel()
        purchaseCancellable?.cancel()
        receiptCancellable?.cancel()

        status?(.processing)

        purchaseCancellable = InAppPurchaseManager.shared.$status
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .removeDuplicates()
            .sink { [weak self] rsp in
                switch rsp {
                    case .failure(_):
                        self?.isPurchasing = false
                        self?.status?(.canPurchase)

                    case .success(let response):
                        var status: InAppPurchaseStatus {
                            switch response {
                            case .purchased:
                                self?.isPurchasing = false
                                return .purchasedSuccess
                            case .purchasing,
                                 .restoring:
                                return .processing
                            case .restored:
                                self?.checkSubscriptions()
                                return .processing
                            default:
                                self?.isPurchasing = false
                                return .canPurchase
                            }
                        }
                        self?.status?(status)
                }
            }

        guard let product = selectedProduct else {
            return
        }
        isPurchasing = true
        InAppPurchaseManager.shared.purchase(product: restore ? nil : product)
    }
}

extension Subscriptions {
    fileprivate func fetchProductInformation() {
        productCancellable?.cancel()
        purchaseCancellable?.cancel()
        receiptCancellable?.cancel()

        status?(.processing)

        productCancellable = InAppPurchaseManager.shared.$products
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { [weak self] rsp in
                switch rsp {
                    case .failure(_):
                        self?.status?(.fail)

                    case .success(let response):
                        guard let product = response.first else {
                            self?.status?(.fail)
                            return
                        }
                        self?.selectedProduct = product
                        self?.status?(.gotProduct(product))
                }
            }

        InAppPurchaseManager.shared.getProducts(for: [identifier])
    }
}
