import MacMagazineLibrary
import SwiftUI

struct CustomTabView: View {
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
            Text("Tabs")
                .font(.headline)
            Text("Escolha a ordem das tabs do aplicativo")
                .font(.caption)
        }
        .foregroundColor(theme.text.terciary.color)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Customize o app, escolhendo a ordem das tabs na parte inferior.")
    }

    var optionsView: some View {
        ForEach($viewModel.tabs, id: \.self) { $tab in
            HStack {
                Image(systemName: tab.icon)
                Text(tab.rawValue)
            }
                .moveDisabled(tab == .search)
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
}
