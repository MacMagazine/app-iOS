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

        if canPurchase {
            InAppPurchase.shared.$error
                .receive(on: RunLoop.main)
                .compactMap { $0 }
                .sink { _ in
                    self.processingStatus(.fail)
                }
                .store(in: &cancellables)

            // Fetch product information.
            fetchProductInformation()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SKPaymentQueue.default().remove(StoreObserver.shared)
    }

    @IBAction private func recover(_ sender: Any) {
        StoreObserver.shared.restore()
    }

    @IBAction private func buy(_ sender: Any) {
        guard let product = selectedProduct else {
            return
        }

        processingStatus(.processing)

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
                buyMessage.text = "Você já é assinante."
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
// 4c45fb4914c84b80919c254d937e4210
// MMReceiptSalt
// [121, 46, 102, 80, 5, 7, 93, 73, 69, 103, 2, 84, 64, 47, 117, 98, 92, 82, 92, 10, 66, 65, 103, 5, 85, 71, 122, 40, 102, 87, 82, 85]
