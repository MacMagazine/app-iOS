import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

struct PushOptionsView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @StateObject private var viewModel = PushOptionsViewModel()

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

private extension PushOptionsView {
    var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Notificações")
                .font(.headline)
            Text("Escolha de quais posts você deseja receber notificações")
                .font(.caption)
        }
        .foregroundColor(theme.text.terciary.color)
    }

    @ViewBuilder
    var optionsView: some View {
        Picker("", selection: $viewModel.type) {
            Text("Todos os posts").tag(PushPreferences.all)
                .accessibilityLabel(PushPreferences.all.accessibilityText(selected: viewModel.type == PushPreferences.all))

            Text("Somente destaques").tag(PushPreferences.featured)
                .accessibilityLabel(PushPreferences.featured.accessibilityText(selected: viewModel.type == PushPreferences.featured))
        }
        .pickerStyle(.segmented)
        .onChange(of: viewModel.type) { _, value in
            #if os(iOS)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            #endif
            Task { await viewModel.change(value) }
        }
    }
}
