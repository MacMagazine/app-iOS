import MacMagazineLibrary
import SwiftUI

struct CustomTabView: View {
    @Environment(\.shouldUseSidebar) private var shouldUseSidebar
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @State private var viewModel = CustomizationViewModel()

    var body: some View {
        Section {
            optionsView
        } header: {
            headerView
        }

        .task {
            viewModel.storage = settingsViewModel.storage
            viewModel.get()
        }
    }
}

private extension CustomTabView {
    var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Abas")
                .font(.headline)
            Text("Defina a ordem das abas do aplicativo")
                .font(.caption)
        }
        .foregroundColor(theme.text.terciary.color)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Customize o app, escolhendo a ordem das abas na parte inferior do aplicativo.")
    }

    var optionsView: some View {
        ForEach($viewModel.tabs, id: \.self) { $tab in
            Label(tab.rawValue, systemImage: tab.icon)
                .moveDisabled(shouldDisableMove(tab))
        }
        .onMove(perform: moveItems)
    }
}

private extension CustomTabView {
    func moveItems(fromIndex: IndexSet, newIndex: Int) {
        viewModel.tabs.move(fromOffsets: fromIndex, toOffset: newIndex)
        Task {
            await viewModel.change(viewModel.tabs)
        }
    }

    func shouldDisableMove(_ tab: AppTabs) -> Bool {
        switch tab {
        case .live, .settings: shouldUseSidebar
        case .search: true
        default: false
        }
    }
}
