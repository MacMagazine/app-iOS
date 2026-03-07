import MacMagazineLibrary
import SwiftUI

public struct MenuView<T: Hashable>: View where T: RawRepresentable, T.RawValue: StringProtocol {
    @Environment(\.theme) private var theme: ThemeColor
    @Binding private var selected: T
    private var menu: [T]

    public var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                ForEach(menu, id: \.self) { option in
                    Button(action: { selected = option },
                           label: {
                        Group {
                            if let icon = (option as? News)?.icon, !icon.isEmpty {
                                Label(option.rawValue, systemImage: icon)
                            } else {
                                Text(option.rawValue)
                            }
                        }
                        .font(.headline)
                        .lineLimit(1)
                    })
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .glassEffect(selected == option ? .clear : .clear.tint(Color.gray.opacity(0.3)),
                                 in: .capsule)
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    public init(menu: [T],
                selected: Binding<T>) {
        self.menu = menu
        _selected = selected
    }
}
