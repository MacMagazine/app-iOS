//
//  Protocols.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 02/03/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import Foundation

// MARK: - StoreObserverDelegate -

protocol StoreObserverDelegate: AnyObject {
    /// Tells the delegate that the restore operation was successful.
    func storeObserverRestoreDidSucceed()

    /// Provides the delegate with messages.
    func storeObserverDidReceiveMessage(_ message: String)
}

// MARK: - StoreManagerDelegate -

protocol StoreManagerDelegate: AnyObject {
    /// Provides the delegate with the App Store's response.
    func storeManagerDidReceiveResponse(_ response: [Section])

    /// Provides the delegate with the error encountered during the product request.
    func storeManagerDidReceiveMessage(_ message: String)
}
