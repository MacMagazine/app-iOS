import Foundation
import MacMagazineLibrary
import SwiftData

@Model
public final class CustomizationDB: Equatable {
    public var id: UUID = UUID()
    var tabs: [AppTabs] = AppTabs.allCases
    var news: [News] = News.allCases
    var social: [Social] = Social.allCases
    var lines: Int = 3
    var modifiedAt: Date = Date()

    init(
        id: UUID = UUID(),
        tabs: [AppTabs] = AppTabs.allCases,
        social: [Social] = Social.allCases,
        news: [News] = News.allCases,
        lines: Int = 3,
        modifiedAt: Date = Date()
    ) {
        self.id = id
        self.tabs = tabs
        self.social = social
        self.news = news
        self.lines = lines
        self.modifiedAt = modifiedAt
    }
}
extension CustomizationDB {
    public static func == (lhs: CustomizationDB, rhs: CustomizationDB) -> Bool {
        lhs.id == rhs.id
    }
}

extension CustomizationDB: ModelDuplicable {
    public static func deduplicate(using context: ModelContext?) {
        let descriptor = FetchDescriptor<CustomizationDB>()
        guard let context,
              let data = try? context.fetch(descriptor) else { return }

        let recordsToDelete = data
            .sorted { $0.modifiedAt > $1.modifiedAt }
            .dropFirst()

        recordsToDelete.forEach { context.delete($0) }
        try? context.save()
    }
}
