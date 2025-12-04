//
//  View+VideoLibrary.swift
//  VideosLibrary
//
//  Created by Renato Ferraz Castelo Branco Ferreira on 03/12/25.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func applyTint(_ tint: Color?) -> some View {
        if let tint {
            self.tint(tint)
        } else {
            self
        }
    }
}
