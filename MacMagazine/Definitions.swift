//
//  Definitions.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 02/03/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import Foundation

/// A structure that is used to represent a list of products or purchases.
struct Section {
    /// Products/Purchases are organized by category.
    var type: SectionType
    /// List of products/purchases.
    var elements = [Any]()
}

/// An enumeration of all the types of products or purchases.
enum SectionType: String, CustomStringConvertible {
    case availableProducts = "AVAILABLE PRODUCTS"
    case invalidProductIdentifiers = "INVALID PRODUCT IDENTIFIERS"
    case purchased = "PURCHASED"
    case restored = "RESTORED"
    case download = "DOWNLOAD"
    case originalTransaction = "ORIGINAL TRANSACTION"
    case productIdentifier = "PRODUCT IDENTIFIER"
    case transactionDate = "TRANSACTION DATE"
    case transactionIdentifier = "TRANSACTION ID"

    var description: String {
        return self.rawValue
    }
}
