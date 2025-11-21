import StoreKit
import SwiftUI
import UIComponentsLibrary

// .tint(theme.button.primary.color ?? .blue)

struct CustomProductViewStyle: ProductViewStyle {
    let theme: Themeable
    let action: () -> Void

    func makeBody(configuration: Configuration) -> some View {
        switch configuration.state {
        case .success(let product):
            content(
                title: product.displayName,
                description: product.description,
                price: product.displayPrice,
                duration: product.subscription?.subscriptionPeriod.debugDescription,
                action: action
            )

        case .loading:
            content(
                title: "Remover Propagandas",
                description: "Assinatura mensal",
                price: "R$ 59,99",
                duration: "",
                action: nil
            ).redacted(reason: .placeholder)

        case .unavailable:
            ErrorView(message: "Assinatura não disponível")

        case let .failure(error):
            ErrorView(message: error.localizedDescription)

        @unknown default: fatalError()
        }
    }
}

extension CustomProductViewStyle {
    @ViewBuilder
    private func content(
        title: String,
        description: String,
        price: String,
        duration: String?,
        action: (() -> Void)?
    ) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(description)
            }
            Spacer()
            Text(price)
                .rounded(fill: theme.button.primary.color ?? .blue)
                .onTapGesture { action?() }
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Assine \(duration != nil ? "por \(duration ?? "")" : "") para remover propagandas por \(price)")
    }
}
