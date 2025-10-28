import MacMagazineLibrary
import InAppLibrary
import SwiftUI

struct SubscriptionItemView: View {
    struct Product {
        let title: String
        let duration: String
        let price: String
        let identifier: String?
        let accessibility: String
    }

    @Environment(\.theme) private var theme: ThemeColor

    let product: Product
    @Binding var selectedProduct: String?
    @State private var isSelected = false

    var body: some View {
        let normalColor = theme.text.terciary.color ?? .black
        let selectedColor = theme.button.secondary.color ?? .blue

        return HStack {
            Text("*\(product.duration)* por **\(product.price)**")
                .foregroundStyle(selectedProduct == product.identifier ? selectedColor : normalColor)

            Spacer()

            Image(systemName: selectedProduct == product.identifier ? "checkmark.circle.fill" : "circle")
                .foregroundColor(selectedProduct == product.identifier ? selectedColor : normalColor)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(product.identifier == nil ? .gray : isSelected ? selectedColor : normalColor, lineWidth: 1.0)
                .background(RoundedRectangle(cornerRadius: 12).fill(theme.main.background.color ?? .white))
        )
        .accessibilityLabel(product.accessibility)
        .redacted(reason: product.identifier == nil ? .placeholder : [])

        .listRowSeparator(.hidden)

        .onTapGesture {
            selectedProduct = product.identifier
        }
    }
}

#Preview {
    let identifier = UUID().uuidString
    return VStack {
        SubscriptionItemView(product: SubscriptionItemView.Product(title: "Assinatura Mensal",
                                                                   duration: "1 mês",
                                                                   price: "R$ 99,90",
                                                                   identifier: nil,
                                                                   accessibility: ""),
                             selectedProduct: .constant(""))

        SubscriptionItemView(product: SubscriptionItemView.Product(title: "Assinatura Mensal",
                                                                   duration: "1 mês",
                                                                   price: "R$ 99,90",
                                                                   identifier: UUID().uuidString,
                                                                   accessibility: ""),
                             selectedProduct: .constant(""))

        SubscriptionItemView(product: SubscriptionItemView.Product(title: "Title",
                                                                   duration: "duration",
                                                                   price: "Price",
                                                                   identifier: identifier,
                                                                   accessibility: ""),
                             selectedProduct: .constant(identifier))

        Spacer()
    }.padding()
}
