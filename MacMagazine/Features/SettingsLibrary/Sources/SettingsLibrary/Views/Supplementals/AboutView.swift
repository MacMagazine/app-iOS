import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

struct AboutView: View {
    @EnvironmentObject private var analytics: AnalyticsManager
    @Environment(\.theme) private var theme: ThemeColor
    private let viewModel = AboutViewModel()

    @Binding var presentingContent: AboutViewModel.ButtonAction

    var body: some View {
        Section {
            optionsView
        } header: {
            headerView
        } footer: {
            footerView
        }
    }
}

private extension AboutView {
    @ViewBuilder
    var footerView: some View {
        Text("MacMagazine é um [projeto de código aberto no GitHub](https://github.com/MacMagazine/app-iOS) liderado por Cassio Rossi.")
            .font(.caption)
            .foregroundColor(theme.text.terciary.color)
            .tint(theme.button.primary.color)
            .padding(.bottom)
    }
}

private extension AboutView {
    var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Sobre")
                .font(.headline)
            Text("Versão \(Bundle.version ?? "")")
                .font(.subheadline)
        }
        .foregroundColor(theme.text.terciary.color)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Sobre. A versão do app é \(Bundle.version ?? "desconhecida").")
    }

    @ViewBuilder
    var optionsView: some View {
        Button(action: {
            viewModel.composeMessage()
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.reportProblem.id,
                screen: AnalyticsConstants.Screen.settings.name
            ))
        },
               label: {
            Text("Relatar problema/bug no app")
                .foregroundStyle(theme.main.tint.color ?? .blue)
        })

        PostsVisibilityView()

        Button(action: {
            presentingContent = .terms
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.termsConditions.id,
                screen: AnalyticsConstants.Screen.settings.name
            ))
        },
               label: {
            Text(AboutViewModel.ButtonAction.terms.title)
                .foregroundStyle(theme.main.tint.color ?? .blue)
        })

        Button(action: {
            presentingContent = .privacy
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.privacyPolicy.id,
                screen: AnalyticsConstants.Screen.settings.name
            ))
        },
               label: {
            Text(AboutViewModel.ButtonAction.privacy.title)
                .foregroundStyle(theme.main.tint.color ?? .blue)
        })
    }
}

#Preview {
    List {
        AboutView(presentingContent: .constant(.privacy))
    }
    .environment(\.theme, ThemeColor())
}
