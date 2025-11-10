import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

struct PushOptionsView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @ObservedObject private var viewModel = PushOptionsViewModel()

    let type: SettingsViewType

    var body: some View {
        content
        .task {
            viewModel.storage = settingsViewModel.storage
            viewModel.get()
        }
    }
}

private extension PushOptionsView {
    @ViewBuilder
    var content: some View {
        switch type {
        case .custom: customView
        case .native: nativeView
        }
    }

    var customView: some View {
        VStack(alignment: .leading) {
            headerView(icon: true)
                .padding(.bottom, 10)
            optionsView
                .padding(.vertical, 8)
        }
    }

    var nativeView: some View {
        Section {
            optionsView
        } header: {
            headerView(icon: false)
        }
    }

    func headerView(icon: Bool) -> some View {
        HStack {
            if icon {
                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 20))
                    .foregroundColor(theme.button.primary.color ?? .blue)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Notificações")
                    .font(.headline)
                Text("Escolha quais posts você deseja receber notificações")
                    .font(.caption)
            }
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
