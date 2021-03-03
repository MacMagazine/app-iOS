//
//  SettingsTableViewController+Assinaturas.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 02/03/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import UIKit

enum ProcessingStatus {
    case processing
    case success
    case fail
}

// MARK: - Assinaturas -

extension SettingsTableViewController {

    func setupInApp() {
        spin.stopAnimating()
        buyBtn.isEnabled = StoreObserver.shared.isAuthorizedForPayments
        restoreBtn.isEnabled = StoreObserver.shared.isAuthorizedForPayments

        if StoreObserver.shared.isAuthorizedForPayments {
            StoreManager.shared.delegate = self
            StoreObserver.shared.delegate = self

            // Fetch product information.
            fetchProductInformation()
        }
    }

    @IBAction private func recover(_ sender: Any) {
        StoreObserver.shared.restore()
    }

    @IBAction private func buy(_ sender: Any) {
        processingStatus(.processing)
    }

    fileprivate func processingStatus(_ status: ProcessingStatus) {
        spin.stopAnimating()
        buyBtn.isHidden = false

        switch status {
            case .processing:
                spin.startAnimating()
                buyBtn.isHidden = true
            case .success:
                break
            case .fail:
                buyBtn.isEnabled = false
                buyBtn.backgroundColor = UIColor(named: "MMGrayWhite")
        }
    }
}

// MARK: - Fetch Product Information -

extension SettingsTableViewController {
    /// Retrieves product information from the App Store.
    fileprivate func fetchProductInformation() {
        processingStatus(.processing)
        StoreManager.shared.startProductRequest(with: ["MMASSINATURAMENSAL"])
    }
}

// MARK: - StoreObserverDelegate -

extension SettingsTableViewController: StoreObserverDelegate {
    func storeObserverDidReceiveMessage(_ message: String) {
        print(#function)
        print(message)
//        alert(with: Messages.purchaseStatus, message: message)
    }

    func storeObserverRestoreDidSucceed() {
        print(#function)
//        handleRestoredSucceededTransaction()
    }
}

// MARK: - StoreManagerDelegate -

/// Extends ParentViewController to conform to StoreManagerDelegate.
extension SettingsTableViewController: StoreManagerDelegate {
    func storeManagerDidReceiveResponse(_ response: [Section]) {
        print(#function)
        print(response)
    }

    func storeManagerDidReceiveMessage(_ message: String) {
        print(#function)
        print(message)
        processingStatus(.fail)
//        alert(with: Messages.productRequestStatus, message: message)
    }
}
