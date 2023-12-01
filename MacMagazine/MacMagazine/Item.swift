//
//  Item.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 01/12/2023.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
