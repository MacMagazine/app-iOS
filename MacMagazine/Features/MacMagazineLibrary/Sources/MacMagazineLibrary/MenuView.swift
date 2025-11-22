import SwiftUI

public struct MenuView<T: Hashable>: View where T: RawRepresentable, T.RawValue: StringProtocol {
    @Environment(\.theme) private var theme: ThemeColor
    @Binding private var selected: T
    private var menu: [T]

    public var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                ForEach(menu, id: \.self) { option in
                    Button(action: { selected = option },
                           label: {
                        Text(option.rawValue)
                            .font(.headline)
                            .rounded(
                                color: theme.button.primary.color ?? .blue,
                                fill: theme.button.terciary.color ?? .gray
                            )
                    })
                }
            }
            .padding(.vertical)
        }
    }

    public init(menu: [T],
                selected: Binding<T>) {
        self.menu = menu
        _selected = selected
    }
}
