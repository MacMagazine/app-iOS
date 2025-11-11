import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

struct AboutView: View {
    @Environment(\.theme) private var theme: ThemeColor
    private let viewModel = AboutViewModel()

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
    }
}

private extension AboutView {
    var headerView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Sobre")
                    .font(.headline)
                Text("Versão \(Bundle.version ?? "")")
                    .font(.subheadline)
            }
        }
        .foregroundColor(theme.text.terciary.color)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Sobre. A versão do app é \(Bundle.version ?? "desconhecida").")
    }

    var optionsView: some View {
        Button(action: {
            viewModel.composeMessage()
        }, label: {
            Text("Relatar problema/bug no app")
                .foregroundStyle(theme.main.tint.color ?? .blue)
        })
    }
}

#Preview {
    VStack {
        AboutView()
        Spacer()
    }
    .padding()
    .environment(\.theme, ThemeColor())
}
