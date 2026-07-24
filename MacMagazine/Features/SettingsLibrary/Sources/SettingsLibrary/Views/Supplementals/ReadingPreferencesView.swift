import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

struct ReadingPreferencesView: View {
    @EnvironmentObject private var analytics: AnalyticsManager
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(SettingsViewModel.self) private var settingsViewModel
    @State private var viewModel = ReadingPreferencesViewModel()
    @State private var showReadConfirmation = false
    @State private var allLines = false
    @State private var rememberFilter = false

    var body: some View {
        Section {
            Toggle("Lembrar último filtro usado", isOn: $rememberFilter)
                .tint(theme.button.primary.color)
            Toggle("Mostrar títulos completos", isOn: $allLines)
                .tint(theme.button.primary.color)
            Toggle("Identificar posts já lidos", isOn: $viewModel.postRead)
                .tint(theme.button.primary.color)

            Button(action: {
                viewModel.markAllAsRead()
                showReadConfirmation = true
                analytics.track(.buttonTap(
                    buttonId: AnalyticsConstants.ButtonID.cleanPostsOptions.id,
                    screen: AnalyticsConstants.Screen.settingsAppearance.name
                ))
            },
                   label: {
                Text("Marcar todos como lidos")
                    .foregroundStyle(theme.main.tint.color ?? .blue)
            })
        } header: {
            Text("Leitura")
                .font(.headline)
                .foregroundColor(theme.text.terciary.color)
        }
        .alert("Todos os posts marcados como lido",
               isPresented: $showReadConfirmation) {
            Button("OK", role: .cancel) {}
        }
        .task {
            viewModel.set(
                storage: settingsViewModel.storage,
                models: settingsViewModel.models
            )
            allLines = settingsViewModel.titleLines == 0
            rememberFilter = settingsViewModel.rememberFilter
        }
        .onChange(of: viewModel.postRead) { _, value in
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.postRead("\(value)").id,
                screen: AnalyticsConstants.Screen.settingsPosts.name
            ))
            Task { await viewModel.change(postRead: value) }
        }
        .onChange(of: allLines) { _, value in
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.allLines("\(value)").id,
                screen: AnalyticsConstants.Screen.settingsPosts.name
            ))
            Task { await settingsViewModel.change(value ? 0 : 3) }
        }
        .onChange(of: rememberFilter) { _, value in
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.rememberFilter("\(value)").id,
                screen: AnalyticsConstants.Screen.settingsPosts.name
            ))
            Task { await settingsViewModel.change(value) }
        }
    }
}

#if DEBUG
import StorageLibrary

#Preview {
    let storage = Database(models: [SettingsDB.self], inMemory: true)

    List {
        ReadingPreferencesView()
    }
    .environment(\.theme, ThemeColor())
    .environment(SettingsViewModel(storage: storage, models: []))
}
#endif
