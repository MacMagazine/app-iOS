import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI

struct FilterPreferencesView: View {
    @EnvironmentObject private var analytics: AnalyticsManager
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(SettingsViewModel.self) private var viewModel
    @State private var rememberFilter = false

    var body: some View {
        Section {
            Toggle("Lembrar último filtro usado", isOn: $rememberFilter)
                .tint(theme.button.primary.color)

        } header: {
            Text("Filtro")
                .font(.headline)
                .foregroundColor(theme.text.terciary.color)

        }
        .task {
            rememberFilter = viewModel.rememberFilter
        }
        .onChange(of: rememberFilter) { _, value in
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.theme("\(value)").id,
                screen: AnalyticsConstants.Screen.settingsAppearance.name
            ))
            Task { await viewModel.change(value) }
        }
    }
}
