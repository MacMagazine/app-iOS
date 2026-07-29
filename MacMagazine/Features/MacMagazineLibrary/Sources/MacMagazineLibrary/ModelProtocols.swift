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

public protocol ModelPrioritizable {}

public extension ModelPrioritizable {
    static func latest<Value>(
        in group: [Self],
        value: (Self) -> Value,
        modifiedAt: (Self) -> Date
    ) -> (value: Value, modifiedAt: Date)? {
        guard let winner = group.max(by: { modifiedAt($0) < modifiedAt($1) }) else { return nil }
        return (value(winner), modifiedAt(winner))
    }
}
