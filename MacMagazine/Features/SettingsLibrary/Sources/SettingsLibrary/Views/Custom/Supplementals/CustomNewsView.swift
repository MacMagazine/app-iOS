import MacMagazineLibrary
import SwiftUI

struct CustomNewsView: View {
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

private extension CustomNewsView {
    var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Notícias")
                .font(.headline)
            Text("Escolha a ordem das notícias no aplicativo")
                .font(.caption)
        }
        .foregroundColor(theme.text.terciary.color)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Customize o app, escolhendo a ordem das notícias.")
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
        }
    }
}
