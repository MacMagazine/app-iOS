import Foundation
import SwiftData

public protocol ModelFavoritable: AnyObject, PersistentModel {
    static func deleteNonFavorites(using context: ModelContext?)
}

public protocol ModelReadable: AnyObject, PersistentModel {
    static func markAllAsRead(using context: ModelContext?)
}

public protocol ModelDuplicable: AnyObject, PersistentModel {
    static func deduplicate(using context: ModelContext?)
}

public protocol ModelPrioritizable {
    var favorite: Bool { get }
    var modifiedAt: Date { get }
}

public extension ModelPrioritizable {
    static func isLessAuthoritative(_ lhs: Self, _ rhs: Self) -> Bool {
        guard lhs.favorite == rhs.favorite else { return rhs.favorite }
        return lhs.modifiedAt < rhs.modifiedAt
    }
}
