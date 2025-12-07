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

    private var storedTabs: [AppTabs] = AppTabs.allCases

    public var tabs: [AppTabs] {
        if !isLive {
            return storedTabs.filter { $0 != .live }
        }
        return storedTabs
    }

    let storage: Database
    let mmLive = MMLiveViewModel()

    public init(storage: Database) {
        self.storage = storage
        self.storedTabs = self.storage.customization?.tabs ?? AppTabs.allCases
        self.social = self.storage.customization?.social ?? Social.allCases
        self.news = self.storage.customization?.news ?? News.allCases

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
}
