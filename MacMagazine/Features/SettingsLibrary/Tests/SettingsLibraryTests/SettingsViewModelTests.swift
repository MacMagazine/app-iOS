import Foundation
import MacMagazineLibrary
@testable import SettingsLibrary
import StorageLibrary
import Testing

@Suite("SettingsViewModel Tests")
@MainActor
struct SettingsViewModelTests {

    // MARK: - Initial State Tests

    @Test("Should start with nil color schema")
    func initialColorSchemaIsNil() {
        let storage = Database(
            models: [SettingsDB.self, CustomizationDB.self],
            inMemory: true
        )
        let sut = SettingsViewModel(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        #expect(sut.colorSchema == nil)
    }

    @Test("Should start with all social options")
    func initialSocialOptionsAreAll() {
        let storage = Database(
            models: [SettingsDB.self, CustomizationDB.self],
            inMemory: true
        )
        let sut = SettingsViewModel(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        #expect(sut.social == Social.allCases)
    }

    @Test("Should start with all news options")
    func initialNewsOptionsAreAll() {
        let storage = Database(
            models: [SettingsDB.self, CustomizationDB.self],
            inMemory: true
        )
        let sut = SettingsViewModel(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        #expect(sut.news == News.allCases)
    }

    @Test("Should start with isLive as false")
    func initialIsLiveIsFalse() {
        let storage = Database(
            models: [SettingsDB.self, CustomizationDB.self],
            inMemory: true
        )
        let sut = SettingsViewModel(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        #expect(!sut.isLive)
    }

    @Test("Should start with removeAds as false")
    func initialRemoveAdsIsFalse() {
        let storage = Database(
            models: [SettingsDB.self, CustomizationDB.self],
            inMemory: true
        )
        let sut = SettingsViewModel(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        #expect(!sut.removeAds)
    }

    // MARK: - Tabs Filtering Tests

    @Test("Should filter out live tab when not live")
    func tabsFilterLiveWhenNotLive() {
        let storage = Database(
            models: [SettingsDB.self, CustomizationDB.self],
            inMemory: true
        )
        let sut = SettingsViewModel(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        sut.isLive = false

        #expect(!sut.tabs.contains(.live))
    }

    @Test("Should include live tab when live")
    func tabsIncludeLiveWhenLive() {
        let storage = Database(
            models: [SettingsDB.self, CustomizationDB.self],
            inMemory: true
        )
        let sut = SettingsViewModel(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        sut.isLive = true

        #expect(sut.tabs.contains(.live))
    }

    @Test("Should always include non-live tabs")
    func tabsAlwaysIncludeNonLive() {
        let storage = Database(
            models: [SettingsDB.self, CustomizationDB.self],
            inMemory: true
        )
        let sut = SettingsViewModel(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        sut.isLive = false
        #expect(sut.tabs.contains(.news))
        #expect(sut.tabs.contains(.social))
        #expect(sut.tabs.contains(.settings))
        #expect(sut.tabs.contains(.search))

        sut.isLive = true
        #expect(sut.tabs.contains(.news))
        #expect(sut.tabs.contains(.social))
        #expect(sut.tabs.contains(.settings))
        #expect(sut.tabs.contains(.search))
    }

    @Test("Tabs count should be 4 when not live")
    func tabsCountNotLive() {
        let storage = Database(
            models: [SettingsDB.self, CustomizationDB.self],
            inMemory: true
        )
        let sut = SettingsViewModel(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        sut.isLive = false

        #expect(sut.tabs.count == 4)
    }

    @Test("Tabs count should be 5 when live")
    func tabsCountLive() {
        let storage = Database(
            models: [SettingsDB.self, CustomizationDB.self],
            inMemory: true
        )
        let sut = SettingsViewModel(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        sut.isLive = true

        #expect(sut.tabs.count == 5)
    }

    // MARK: - Color Schema Tests

    @Test("Should support light color schema")
    func lightColorSchema() {
        let storage = Database(
            models: [SettingsDB.self, CustomizationDB.self],
            inMemory: true
        )
        let sut = SettingsViewModel(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        sut.colorSchema = .light

        #expect(sut.colorSchema == .light)
    }

    @Test("Should support dark color schema")
    func darkColorSchema() {
        let storage = Database(
            models: [SettingsDB.self, CustomizationDB.self],
            inMemory: true
        )
        let sut = SettingsViewModel(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        sut.colorSchema = .dark

        #expect(sut.colorSchema == .dark)
    }

    @Test("Should support nil color schema for system default")
    func systemColorSchema() {
        let storage = Database(
            models: [SettingsDB.self, CustomizationDB.self],
            inMemory: true
        )
        let sut = SettingsViewModel(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        sut.colorSchema = nil

        #expect(sut.colorSchema == nil)
    }

    // MARK: - Social Options Tests

    @Test("Should update social options")
    func updateSocialOptions() {
        let storage = Database(
            models: [SettingsDB.self, CustomizationDB.self],
            inMemory: true
        )
        let sut = SettingsViewModel(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        let customSocial: [Social] = [.videos, .podcast]
        sut.social = customSocial

        #expect(sut.social == customSocial)
    }

    @Test("Should allow empty social options")
    func emptySocialOptions() {
        let storage = Database(
            models: [SettingsDB.self, CustomizationDB.self],
            inMemory: true
        )
        let sut = SettingsViewModel(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        sut.social = []

        #expect(sut.social.isEmpty)
    }

    // MARK: - News Options Tests

    @Test("Should update news options")
    func updateNewsOptions() {
        let storage = Database(
            models: [SettingsDB.self, CustomizationDB.self],
            inMemory: true
        )
        let sut = SettingsViewModel(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        let customNews: [News] = [.highlights, .reviews]
        sut.news = customNews

        #expect(sut.news == customNews)
    }

    @Test("Should allow empty news options")
    func emptyNewsOptions() {
        let storage = Database(
            models: [SettingsDB.self, CustomizationDB.self],
            inMemory: true
        )
        let sut = SettingsViewModel(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        sut.news = []

        #expect(sut.news.isEmpty)
    }

    // MARK: - RemoveAds Tests

    @Test("Should update removeAds flag")
    func updateRemoveAds() {
        let storage = Database(
            models: [SettingsDB.self, CustomizationDB.self],
            inMemory: true
        )
        let sut = SettingsViewModel(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        sut.removeAds = true

        #expect(sut.removeAds)
    }

    // MARK: - Live Status Tests

    @Test("Should update isLive flag")
    func updateIsLive() {
        let storage = Database(
            models: [SettingsDB.self, CustomizationDB.self],
            inMemory: true
        )
        let sut = SettingsViewModel(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        sut.isLive = true

        #expect(sut.isLive)
    }

    @Test("Live status should affect tabs")
    func liveStatusAffectsTabs() {
        let storage = Database(
            models: [SettingsDB.self, CustomizationDB.self],
            inMemory: true
        )
        let sut = SettingsViewModel(storage: storage, models: [SettingsDB.self, CustomizationDB.self])

        sut.isLive = false
        let tabsWithoutLive = sut.tabs

        sut.isLive = true
        let tabsWithLive = sut.tabs

        #expect(tabsWithLive.count == tabsWithoutLive.count + 1)
        #expect(tabsWithLive.contains(.live))
        #expect(!tabsWithoutLive.contains(.live))
    }
}
