import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

public struct AboutView: View {
    @Environment(\.theme) private var theme: ThemeColor
    private let viewModel = AboutViewModel()

    public init() {}

    public var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(theme.button.primary.color ?? .blue)
                VStack(alignment: .leading, spacing: 4) {
                    Text("SOBRE")
                        .font(.headline)
                    Text("Versão \(Bundle.version ?? "")")
                        .font(.subheadline)
                }
            }
            .foregroundColor(theme.text.terciary.color)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Sobre. A versão do app é \(Bundle.version ?? "desconhecida").")

            Button(action: {
                viewModel.composeMessage()
            }, label: {
                Text("Relatar problema/bug no app".uppercased())
                    .borderedFullSize(color: theme.text.primary.color ?? .primary,
                                      stroke: theme.button.secondary.color ?? .blue)
            })
            .padding(.vertical, 10)

            footerView
        }
        .padding(.bottom, 8)
    }
}

extension AboutView {
    @ViewBuilder
    private var footerView: some View {
        Text("MacMagazine é um [projeto de código aberto no GitHub](https://github.com/MacMagazine/app-iOS) liderado por Cassio Rossi.")
            .font(.caption)
            .foregroundColor(theme.text.terciary.color)
            .tint(theme.button.primary.color)
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
