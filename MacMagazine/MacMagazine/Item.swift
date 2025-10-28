//
//  Item.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 09/10/2025.
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
