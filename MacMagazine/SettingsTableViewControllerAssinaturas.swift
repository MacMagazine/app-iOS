//
//  SettingsTableViewController+Assinaturas.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 02/03/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import Combine
import InAppPurchase
import StoreKit
import UIKit

enum ProcessingStatus {
    case processing
    case gotProductPrice(String)
    case purchasedSuccess
    case fail
}

// MARK: - Assinaturas -

extension SettingsTableViewController {

    func setupInApp() {
        let canPurchase = InAppPurchase.shared.canPurchase

        spin.stopAnimating()
        buyBtn.isEnabled = canPurchase
        restoreBtn.isEnabled = canPurchase
        purchasedMessage.isHidden = true

        if canPurchase {
            if Settings().purchased {
                processingStatus(.purchasedSuccess)
            } else {
                fetchProductInformation()
            }
        }
    }

    @IBAction private func recover(_ sender: Any) {
        processingStatus(.processing)

        InAppPurchase.shared.$error
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { _ in
                self.processingStatus(.fail)
            }
            .store(in: &cancellables)

        InAppPurchase.shared.$success
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink {
                if $0 {
                    self.processingStatus(.purchasedSuccess)
                } else {
                    self.processingStatus(.fail)
                }
            }
            .store(in: &cancellables)

        InAppPurchase.shared.restore()
    }

    @IBAction private func buy(_ sender: Any) {
        guard let product = selectedProduct else {
            return
        }

        processingStatus(.processing)

        InAppPurchase.shared.$error
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { _ in
                self.processingStatus(.fail)
            }
            .store(in: &cancellables)

        InAppPurchase.shared.$success
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink {
                if $0 {
                    self.processingStatus(.purchasedSuccess)
                } else {
                    self.processingStatus(.fail)
                }
            }
            .store(in: &cancellables)

        InAppPurchase.shared.buy(product: product)
    }
}

// MARK: - Fetch Product Information -

extension SettingsTableViewController {
    fileprivate func fetchProductInformation() {
        processingStatus(.processing)

        InAppPurchase.shared.$error
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { _ in
                self.processingStatus(.fail)
            }
            .store(in: &cancellables)

        InAppPurchase.shared.$products
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink {
                guard let product = $0.first,
                      let price = product.price else {
                    self.processingStatus(.fail)
                    return
                }
                self.selectedProduct = product
                self.processingStatus(.gotProductPrice(price))
            }
            .store(in: &cancellables)

        InAppPurchase.shared.getProducts(for: ["MMASSINATURAMENSAL"])
    }

    fileprivate func processingStatus(_ status: ProcessingStatus) {
        spin.stopAnimating()
        buyBtn.isHidden = false
        buyBtn.setTitle("-", for: .normal)
        restoreBtn.isEnabled = true

        switch status {
            case .processing:
                spin.startAnimating()
                buyBtn.isHidden = true

            case .gotProductPrice(let price):
                buyBtn.setTitle(price, for: .normal)

            case .purchasedSuccess:
                buyBtn.isHidden = true
                buyMessage.isHidden = true
                purchasedMessage.isHidden = false
                restoreBtn.isEnabled = false
                patraoButton.isEnabled = false

                var settings = Settings()
                settings.purchased = true

            case .fail:
                buyBtn.isEnabled = false
                buyBtn.backgroundColor = UIColor(named: "MMGrayWhite")
        }
    }
}
