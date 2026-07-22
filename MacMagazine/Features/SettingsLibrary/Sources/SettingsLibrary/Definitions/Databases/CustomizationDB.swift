import Foundation
import MacMagazineLibrary
import SwiftData

@Model
public final class CustomizationDB: Equatable {
    public var id: UUID = UUID()
    var tabsRaw: [String] = AppTabs.allCases.map(\.rawValue)
    var newsRaw: [String] = News.allCases.map(\.rawValue)
    var socialRaw: [String] = Social.allCases.map(\.rawValue)
    var lines: Int = 3
    var rememberFilter: Bool = false
    var filterRaw: String?
    var modifiedAt: Date = Date()

    // CloudKit only mirrors arrays of primitive types, so the enum arrays above
    // are persisted as [String] and exposed here as their typed equivalents.
    var tabs: [AppTabs] {
        get { tabsRaw.compactMap(AppTabs.init(rawValue:)) }
        set { tabsRaw = newValue.map(\.rawValue) }
    }

    var news: [News] {
        get { newsRaw.compactMap(News.init(rawValue:)) }
        set { newsRaw = newValue.map(\.rawValue) }
    }

    var social: [Social] {
        get { socialRaw.compactMap(Social.init(rawValue:)) }
        set { socialRaw = newValue.map(\.rawValue) }
    }

    var filter: News? {
        get { filterRaw.flatMap(News.init(rawValue:)) }
        set { filterRaw = newValue?.rawValue }
    }

    init(
        id: UUID = UUID(),
        tabs: [AppTabs] = AppTabs.allCases,
        social: [Social] = Social.allCases,
        news: [News] = News.allCases,
        lines: Int = 3,
        rememberFilter: Bool = false,
        filter: News? = nil,
        modifiedAt: Date = Date()
    ) {
        self.id = id
        self.tabsRaw = tabs.map(\.rawValue)
        self.socialRaw = social.map(\.rawValue)
        self.newsRaw = news.map(\.rawValue)
        self.lines = lines
        self.rememberFilter = rememberFilter
        self.filterRaw = filter?.rawValue
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
