import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

struct AboutView: View {
    @Environment(\.theme) private var theme: ThemeColor
    private let viewModel = AboutViewModel()

    let type: SettingsViewType

    var body: some View {
        content
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
            VStack(alignment: .leading) {
                optionsView
                    .padding(.vertical, 8)
                footerView
            }
        }
    }

    var nativeView: some View {
        Section {
            optionsView
        } header: {
            headerView(icon: false)
        } footer: {
            footerView
        }
    }

    func headerView(icon: Bool) -> some View {
        HStack(alignment: .top) {
            if icon {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(theme.button.primary.color ?? .blue)
            }

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
            switch type {
            case .custom:
                Text("Relatar problema/bug no app".uppercased())
                    .borderedFullSize(color: theme.text.primary.color ?? .primary,
                                      stroke: theme.button.secondary.color ?? .blue)
            case .native:
                Text("Relatar problema/bug no app")
                    .foregroundStyle(theme.main.tint.color ?? .blue)
            }

        })
        .padding(.vertical, 10)
    }
}

#Preview {
    VStack {
        AboutView(type: .custom)
        Spacer()
    }
    .padding()
    .environment(\.theme, ThemeColor())
}
