import Foundation
import SwiftData

@Model
public final class RecentSearchDB {
    public var query: String = ""
    public var timestamp: Date = Date()

    public init(query: String = "", timestamp: Date = Date()) {
        self.query = query
        self.timestamp = timestamp
    }
}
