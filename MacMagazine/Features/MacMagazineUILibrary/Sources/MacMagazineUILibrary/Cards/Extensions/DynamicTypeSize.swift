import SwiftUI

public extension DynamicTypeSize {
    var usesPrimaryCardLayout: Bool {
        switch self {
        case .accessibility1...: false
        default: true
        }
    }
}
