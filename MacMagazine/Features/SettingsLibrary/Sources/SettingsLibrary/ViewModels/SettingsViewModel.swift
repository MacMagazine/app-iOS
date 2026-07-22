import MacMagazineLibrary
import MMLiveLibrary
import StorageLibrary
import SwiftData
import SwiftUI

@MainActor
@Observable
final public class SettingsViewModel {
    public var colorSchema: SwiftUI.ColorScheme?
    public var social: [Social] = Social.allCases
    public var news: [News] = News.allCases
    public var isLive = false
    public var removeAds = false
    public var highlightPostRead = false
    public var titleLines = 3
    public var rememberFilter = false
    public var filter: News?

    private var storedTabs: [AppTabs] = AppTabs.allCases

    public var tabs: [AppTabs] {
        if !isLive {
            return storedTabs.filter { $0 != .live }
        }
        return storedTabs
    }

    let storage: Database
    let models: [any PersistentModel.Type]

    let mmLive: MMLiveViewModel

    public init(
        storage: Database,
        models: [any PersistentModel.Type],
        mmLive: MMLiveViewModel = MMLiveViewModel()
    ) {
        self.storage = storage
        self.models = models
        self.mmLive = mmLive
        self.storedTabs = self.storage.customization?.tabs ?? AppTabs.allCases
        self.social = self.storage.customization?.social ?? Social.allCases
        self.news = self.storage.customization?.news ?? News.allCases
        self.removeAds = self.storage.settings?.subscription.removeAds ?? false
        self.highlightPostRead = self.storage.settings?.postRead ?? true
        self.titleLines = self.storage.customization?.lines ?? 3
        self.rememberFilter = self.storage.customization?.rememberFilter ?? false
        self.filter = self.storage.customization?.filter

        updateSchema()

        NotificationCenter.default.addObserver(
            forName: ModelContext.didSave,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.updateSchema()
                self?.storedTabs = self?.storage.customization?.tabs ?? AppTabs.allCases
                self?.social = self?.storage.customization?.social ?? Social.allCases
                self?.news = self?.storage.customization?.news ?? News.allCases
                self?.removeAds = self?.storage.settings?.subscription.removeAds ?? false
                self?.highlightPostRead = self?.storage.settings?.postRead ?? true
                self?.titleLines = self?.storage.customization?.lines ?? 3
                self?.rememberFilter = self?.storage.customization?.rememberFilter ?? false
                self?.filter = self?.storage.customization?.filter
            }
        }
    }

    public func updateTabs(currentTab: Binding<AppTabs>? = nil) {
        Task { @MainActor in
            isLive = await mmLive.isLive()

            // If .live tab is being removed and it's currently selected, switch to first available tab
            if !isLive, let binding = currentTab, binding.wrappedValue == .live {
                binding.wrappedValue = tabs.first ?? .news
            }
        }
    }

    @MainActor
    public func change(_ filter: News) async {
        storage.update(filter: filter)
    }
}

extension SettingsViewModel {
    private func updateSchema() {
        guard let mode = storage.settings?.mode else {
            colorSchema = nil
            return
        }
        colorSchema = switch mode {
        case .light: SwiftUI.ColorScheme.light
        case .dark: SwiftUI.ColorScheme.dark
        case .system: nil
        }
    }

    @MainActor
    func change(_ titleLines: Int) async {
        storage.update(lines: titleLines)
    }

    @MainActor
    func change(_ rememberFilter: Bool) async {
        storage.update(rememberFilter: rememberFilter)
        if !rememberFilter {
            storage.update(filter: nil)
        }
    }
}
