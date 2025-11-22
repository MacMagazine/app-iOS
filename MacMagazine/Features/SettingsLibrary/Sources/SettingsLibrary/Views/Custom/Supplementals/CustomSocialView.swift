import MacMagazineLibrary
import SwiftUI

struct CustomSocialView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    private var viewModel = CustomizationViewModel()

    var body: some View {
        Section {
            optionsView
        } header: {
            headerView
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
        EmptyView()
    }
}
