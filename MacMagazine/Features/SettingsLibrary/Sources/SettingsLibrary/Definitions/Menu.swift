import Foundation
import SwiftUI

struct Menu: Identifiable {
    let id = UUID()
    let view: AnyView
    let children: [Menu]?

    init(view: AnyView,
         children: [Menu]? = nil) {
        self.view = view
        self.children = children
    }
}
