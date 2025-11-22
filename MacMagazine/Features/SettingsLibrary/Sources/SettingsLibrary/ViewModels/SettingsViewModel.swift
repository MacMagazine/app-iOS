import Combine
import StorageLibrary
import SwiftData
import SwiftUI

@MainActor
final public class SettingsViewModel: ObservableObject {
    @Published public var colorSchema: SwiftUI.ColorScheme?
    @Published public var tabs: [AppTabs] = AppTabs.allCases
    @Published public var social: [Social] = Social.allCases
    @Published public var news: [News] = News.allCases

    let storage: Database

    public init(storage: Database) {
        self.storage = storage
        self.tabs = self.storage.get()?.tabs ?? AppTabs.allCases
        self.social = self.storage.get()?.social ?? Social.allCases
        self.news = self.storage.get()?.news ?? News.allCases

        NotificationCenter.default.addObserver(
            forName: ModelContext.didSave,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.updateSchema()
                self?.tabs = self?.storage.get()?.tabs ?? AppTabs.allCases
                self?.social = self?.storage.get()?.social ?? Social.allCases
                self?.news = self?.storage.get()?.news ?? News.allCases
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
