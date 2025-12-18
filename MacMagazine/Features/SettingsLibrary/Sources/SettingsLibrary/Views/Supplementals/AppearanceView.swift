import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI

struct AppearanceView: View {
    @EnvironmentObject private var analytics: AnalyticsManager
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(SettingsViewModel.self) private var settingsViewModel
    @State private var viewModel = AppearanceViewModel()

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

        .onChange(of: viewModel.mode) { _, value in
            analytics.track(.buttonTap(buttonId: "tema \(value)", screen: "Ajustes > Aparência"), providers: [.firebase])
            Task { await viewModel.change(value) }
        }
    }
}

private extension AppearanceView {
    var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Tema")
                .font(.headline)
            Text("Escolha o tema do aplicativo")
                .font(.caption)
        }
        .foregroundColor(theme.text.terciary.color)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Mude a aparência, escolhendo o tema do aplicativo")
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

#if DEBUG
import StorageLibrary

#Preview {
    let storage = Database(models: [SettingsDB.self], inMemory: true)

    List {
        AppearanceView()
    }
    .environment(\.theme, ThemeColor())
    .environment(SettingsViewModel(storage: storage, models: []))
}
#endif
