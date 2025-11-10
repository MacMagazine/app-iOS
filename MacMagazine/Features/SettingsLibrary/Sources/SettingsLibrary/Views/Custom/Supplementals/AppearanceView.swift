import MacMagazineLibrary
import SwiftUI

struct AppearanceView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @ObservedObject private var viewModel = AppearanceViewModel()

    let type: SettingsViewType

    var body: some View {
        content
        .task {
            viewModel.storage = settingsViewModel.storage
            viewModel.get()
        }

        .onChange(of: viewModel.mode) { _, value in
            Task { await viewModel.change(value) }
        }
    }
}

private extension AppearanceView {
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
                Image(systemName: "paintbrush.fill")
                    .font(.system(size: 20))
                    .foregroundColor(theme.button.primary.color ?? .blue)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Aparência")
                    .font(.headline)
                Text("Escolha o tema do aplicativo")
                    .font(.caption)
            }
        }
        .foregroundColor(theme.text.terciary.color)
    }

    var optionsView: some View {
        Picker("", selection: $viewModel.mode) {
            Text("Clara").tag(ColorScheme.light)
                .accessibilityLabel(ColorScheme.light.accessibilityText(selected: viewModel.mode == ColorScheme.light))

            Text("Escura").tag(ColorScheme.dark)
                .accessibilityLabel(ColorScheme.dark.accessibilityText(selected: viewModel.mode == ColorScheme.dark))

            Text("Sistema").tag(ColorScheme.system)
                .accessibilityLabel(ColorScheme.system.accessibilityText(selected: viewModel.mode == ColorScheme.system))
        }
        .pickerStyle(.segmented)
    }
}
