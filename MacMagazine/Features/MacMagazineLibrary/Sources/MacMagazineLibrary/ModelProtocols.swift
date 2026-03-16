import Foundation
import SwiftData

public protocol ModelFavoritable: AnyObject, PersistentModel {
    static func deleteNonFavorites(using context: ModelContext?)
}

public protocol ModelDuplicable: AnyObject, PersistentModel {
    static func deduplicate(using context: ModelContext?)
}
