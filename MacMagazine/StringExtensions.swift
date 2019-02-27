//
//  StringExtensions.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 27/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import Foundation

extension String {

    func toDate(_ format: String?) -> Date {
        // Expected date format: "Tue, 26 Feb 2019 23:00:53 +0000"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format ?? "EEE, dd MMM yyyy HH:mm:ss +0000"
        return dateFormatter.date(from: self) ?? Date()
    }

}
