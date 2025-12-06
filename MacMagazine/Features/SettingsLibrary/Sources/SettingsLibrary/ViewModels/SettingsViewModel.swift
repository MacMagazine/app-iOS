import Combine
import MMLiveLibrary
import StorageLibrary
import SwiftData
import SwiftUI

@MainActor
final public class SettingsViewModel: ObservableObject {
    @Published public var colorSchema: SwiftUI.ColorScheme?
    @Published public var tabs: [AppTabs] = AppTabs.allCases
    @Published public var social: [Social] = Social.allCases
    @Published public var news: [News] = News.allCases
    @Published var isLive = false

    let storage: Database
    let mmLive = MMLiveViewModel()

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

    public func updateTabs() {
        Task { @MainActor in
            isLive = await mmLive.isLive()
            print("==> \(isLive)")
            if !isLive {
                tabs.removeAll(where: { $0 == .live })
                print("==> \(tabs)")
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
