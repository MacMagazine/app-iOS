//
//  ReceiptManager.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 03/03/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import Foundation
import StoreKit

class ReceiptManager: NSObject {

    // MARK: - Properties -

    static let shared = ReceiptManager()

    var receipt: Data? {
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
              FileManager.default.fileExists(atPath: appStoreReceiptURL.path),
              let rawReceiptData = try? Data(contentsOf: appStoreReceiptURL) else {
            return nil
        }
        return rawReceiptData
    }

    enum VerifyReceiptURL: String {
        case production = "https://buy.itunes.apple.com/verifyReceipt"
        case sandbox = "https://sandbox.itunes.apple.com/verifyReceipt"
    }

    // MARK: - Methods -

    func validate(receipt: Data, secret: String) {
    }
}
