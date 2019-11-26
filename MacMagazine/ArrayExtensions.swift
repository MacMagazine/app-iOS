//
//  ArrayExtensions.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 26/11/19.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
