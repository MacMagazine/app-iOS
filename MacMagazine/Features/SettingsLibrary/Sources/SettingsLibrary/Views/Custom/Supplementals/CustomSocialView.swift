import MacMagazineLibrary
import SwiftUI

struct CustomSocialView: View {
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

private extension CustomSocialView {
    var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Social")
                .font(.headline)
            Text("Escolha a ordem de Social no aplicativo")
                .font(.caption)
        }
        .foregroundColor(theme.text.terciary.color)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Customize o app, escolhendo a ordem das opções em Social.")
    }

    var optionsView: some View {
        ForEach($viewModel.social, id: \.self) { $social in
            Text(social.rawValue)
        }
        .onMove(perform: moveItems)
    }
}

private extension CustomSocialView {
    func moveItems(fromIndex: IndexSet, newIndex: Int) {
        viewModel.social.move(fromOffsets: fromIndex, toOffset: newIndex)
        Task {
            await viewModel.change(viewModel.social)
        }
    }
}
