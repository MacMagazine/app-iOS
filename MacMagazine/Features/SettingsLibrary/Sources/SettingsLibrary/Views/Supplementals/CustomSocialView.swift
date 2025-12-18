import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI

struct CustomSocialView: View {
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

private extension CustomSocialView {
    var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(AppTabs.social.rawValue)
                .font(.headline)
            Text("Defina a ordem das \(AppTabs.social.rawValue.lowercased()) do aplicativo")
                .font(.caption)
        }
        .foregroundColor(theme.text.terciary.color)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Customize o app, escolhendo a ordem das opções na aba \(AppTabs.social.rawValue.lowercased()).")
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
            analytics.track(.generic(name: AnalyticsConstants.GenericEvent.socialOrder.name, item: viewModel.social))
        }
    }
}
