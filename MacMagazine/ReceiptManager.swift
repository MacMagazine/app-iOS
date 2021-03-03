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
// 4c45fb4914c84b80919c254d937e4210
// MMReceiptSalt
// [121, 46, 102, 80, 5, 7, 93, 73, 69, 103, 2, 84, 64, 47, 117, 98, 92, 82, 92, 10, 66, 65, 103, 5, 85, 71, 122, 40, 102, 87, 82, 85]
