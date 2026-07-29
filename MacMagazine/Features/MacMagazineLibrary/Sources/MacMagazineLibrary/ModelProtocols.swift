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

public protocol ModelPrioritizable: AnyObject {}

public extension ModelPrioritizable {
    /// Picks the most authoritative value of a field across a group of duplicates, by the
    /// field's own timestamp. `preferOnTie` breaks an exact timestamp tie deterministically -
    /// independent of the group's iteration order, which SwiftData does not guarantee stable -
    /// by returning `true` when `candidate` should replace `current`.
    static func latest<Value>(
        in group: [Self],
        value: (Self) -> Value,
        modifiedAt: (Self) -> Date,
        preferOnTie: (_ candidate: Value, _ current: Value) -> Bool
    ) -> (value: Value, modifiedAt: Date)? {
        guard var winner = group.first else { return nil }
        for candidate in group.dropFirst() {
            let winnerDate = modifiedAt(winner)
            let candidateDate = modifiedAt(candidate)
            if candidateDate > winnerDate {
                winner = candidate
            } else if candidateDate == winnerDate, preferOnTie(value(candidate), value(winner)) {
                winner = candidate
            }
        }
        return (value(winner), modifiedAt(winner))
    }

    /// Groups `data` by `postId`, keeps the most recently modified record per group as the
    /// survivor, lets `merge` reconcile per-field state onto it, then hands every other record
    /// in the group to `delete`.
    static func resolveDuplicates(
        in data: [Self],
        postId: (Self) -> String,
        modifiedAt: (Self) -> Date,
        merge: (_ survivor: Self, _ group: [Self]) -> Void,
        delete: (Self) -> Void
    ) {
        for group in Dictionary(grouping: data, by: postId).values where group.count > 1 {
            guard let survivor = group.max(by: { modifiedAt($0) < modifiedAt($1) }) else { continue }
            merge(survivor, group)
            for record in group where record !== survivor {
                delete(record)
            }
        }
    }
}
