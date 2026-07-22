import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI

struct CustomCardsView: View {
    @EnvironmentObject private var analytics: AnalyticsManager
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(SettingsViewModel.self) private var viewModel
    @State private var allLines = false

    var body: some View {
        Section {
            Toggle("Mostrar título completo", isOn: $allLines)
                .tint(theme.button.primary.color)

        } header: {
            Text("Título")
                .font(.headline)
                .foregroundColor(theme.text.terciary.color)

        }
        .task {
            allLines = viewModel.titleLines == 0
        }
        .onChange(of: allLines) { _, value in
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.theme("\(value)").id,
                screen: AnalyticsConstants.Screen.settingsAppearance.name
            ))
            Task { await viewModel.change(value ? 0 : 3) }
        }
    }
}
