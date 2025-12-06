import Combine
import MMLiveLibrary
import StorageLibrary
import SwiftData
import SwiftUI

@MainActor
final public class SettingsViewModel: ObservableObject {
    @Published public var colorSchema: SwiftUI.ColorScheme?
    @Published public var social: [Social] = Social.allCases
    @Published public var news: [News] = News.allCases
    @Published public var isLive = false

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
        self.storedTabs = self.storage.get()?.tabs ?? AppTabs.allCases
        self.social = self.storage.get()?.social ?? Social.allCases
        self.news = self.storage.get()?.news ?? News.allCases

        NotificationCenter.default.addObserver(
            forName: ModelContext.didSave,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.updateSchema()
                self?.storedTabs = self?.storage.get()?.tabs ?? AppTabs.allCases
                self?.social = self?.storage.get()?.social ?? Social.allCases
                self?.news = self?.storage.get()?.news ?? News.allCases
            }
        }
    }

    public func updateTabs(currentTab: Binding<AppTabs>? = nil) {
        Task { @MainActor in
            let wasLive = isLive
            isLive = await mmLive.isLive()

            // If .live tab is being removed and it's currently selected, switch to first available tab
            if !isLive, let binding = currentTab, binding.wrappedValue == .live {
                binding.wrappedValue = tabs.first ?? .news
            }

            // Manually trigger update if isLive changed
            if wasLive != isLive {
                objectWillChange.send()
            }
        }
    }
}

extension SettingsViewModel {
    private func updateSchema() {
        guard let mode = storage.get()?.mode else {
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
