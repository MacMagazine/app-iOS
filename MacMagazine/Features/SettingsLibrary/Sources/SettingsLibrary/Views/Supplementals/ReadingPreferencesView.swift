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

    var body: some View {
        Section {
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
        }
        .onChange(of: viewModel.postRead) { _, value in
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.theme("\(value)").id,
                screen: AnalyticsConstants.Screen.settingsAppearance.name
            ))
            Task { await viewModel.change(postRead: value) }
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
