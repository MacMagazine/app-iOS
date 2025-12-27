import Foundation
@testable import MacMagazineLibrary
import Testing

@Suite("AppTabs Tests")
struct AppTabsTests {

    @Test("Should be Codable - encode and decode round trip")
    func codableRoundTrip() throws {
        for tab in AppTabs.allCases {
            let encoded = try JSONEncoder().encode(tab)
            let decoded = try JSONDecoder().decode(AppTabs.self, from: encoded)
            #expect(decoded == tab)
        }
    }

    @Test("Should be usable as dictionary keys")
    func usableAsDictionaryKeys() {
        var dict: [AppTabs: Int] = [:]
        for (index, tab) in AppTabs.allCases.enumerated() {
            dict[tab] = index
        }
        #expect(dict.count == AppTabs.allCases.count)
    }
}

@Suite("News Tests")
struct NewsTests {

    @Test("Should be Codable - encode and decode round trip")
    func codableRoundTrip() throws {
        for news in News.allCases {
            let encoded = try JSONEncoder().encode(news)
            let decoded = try JSONDecoder().decode(News.self, from: encoded)
            #expect(decoded == news)
        }
    }

    @Test("Should be usable as dictionary keys")
    func usableAsDictionaryKeys() {
        var dict: [News: Int] = [:]
        for (index, news) in News.allCases.enumerated() {
            dict[news] = index
        }
        #expect(dict.count == News.allCases.count)
    }
}

@Suite("Social Tests")
struct SocialTests {

    @Test("Should be Codable - encode and decode round trip")
    func codableRoundTrip() throws {
        for social in Social.allCases {
            let encoded = try JSONEncoder().encode(social)
            let decoded = try JSONDecoder().decode(Social.self, from: encoded)
            #expect(decoded == social)
        }
    }

    @Test("Should be usable as dictionary keys")
    func usableAsDictionaryKeys() {
        var dict: [Social: Int] = [:]
        for (index, social) in Social.allCases.enumerated() {
            dict[social] = index
        }
        #expect(dict.count == Social.allCases.count)
    }
}

@Suite("areEqual Function Tests")
struct AreEqualTests {

    @Test("Should return true for same enum values")
    func sameValues() {
        #expect(areEqual(AppTabs.live, AppTabs.live))
        #expect(areEqual(News.all, News.all))
        #expect(areEqual(Social.videos, Social.videos))
    }

    @Test("Should return false for different values of same type")
    func differentValuesSameType() {
        #expect(!areEqual(AppTabs.live, AppTabs.news))
        #expect(!areEqual(News.all, News.highlights))
        #expect(!areEqual(Social.videos, Social.podcast))
    }

    @Test("Should return false for different enum types")
    func differentTypes() {
        #expect(!areEqual(AppTabs.news, News.news))
        #expect(!areEqual(Social.videos, News.all))
    }
}
