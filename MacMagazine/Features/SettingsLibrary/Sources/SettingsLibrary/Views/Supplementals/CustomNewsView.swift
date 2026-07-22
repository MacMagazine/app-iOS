import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI

struct CustomNewsView: View {
    @EnvironmentObject private var analytics: AnalyticsManager
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(SettingsViewModel.self) private var settingsViewModel
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

private extension CustomNewsView {
    var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(AppTabs.news.rawValue)
                .font(.headline)
            Text("Defina a ordem dos filtros de \(AppTabs.news.rawValue.lowercased()) do aplicativo")
                .font(.caption)
        }
        .foregroundColor(theme.text.terciary.color)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Customize o app, escolhendo a ordem dos filtros da aba \(AppTabs.news.rawValue.lowercased()).")
    }

    var optionsView: some View {
        ForEach($viewModel.news, id: \.self) { $news in
            Text(news.rawValue)
        }
        .onMove(perform: moveItems)
    }
}

private extension CustomNewsView {
    func moveItems(fromIndex: IndexSet, newIndex: Int) {
        viewModel.news.move(fromOffsets: fromIndex, toOffset: newIndex)
        Task {
            await viewModel.change(viewModel.news)
            analytics.track(.generic(name: AnalyticsConstants.GenericEvent.newsOrder.name, item: viewModel.news))
        }
    }
}
