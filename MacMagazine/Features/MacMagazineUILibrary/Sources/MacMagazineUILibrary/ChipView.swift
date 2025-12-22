import MacMagazineLibrary
import SwiftUI

public struct ChipView<T: Hashable>: View where T: RawRepresentable, T.RawValue: StringProtocol {
    private struct RowWrapper: Identifiable {
        let id = UUID()
        let index: Int
        let row: [T]
    }

    @Environment(\.theme) private var theme: ThemeColor
    @Binding private var selected: T
    private var options: [T]

    public var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 10) {
                ForEach(getRows(geometry: geo).enumerated().map {
                    RowWrapper(index: $0.offset, row: $0.element)
                }) { rowWrapper in
                    HStack(alignment: .center, spacing: 10) {
                        ForEach(rowWrapper.row, id: \.self) { item in
                            Button(action: { selected = item },
                                   label: {
                                Text(item.rawValue)
                                    .font(.body)
                                    .lineLimit(1)
                            })
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .glassEffect(.clear, in: .rect(cornerRadius: 24))
                        }
                    }
                    .frame(width: geo.size.width, alignment: .center)
                }
            }
            .padding(.bottom)
        }
    }

    public init(options: [T],
                selected: Binding<T>) {
        self.options = options
        _selected = selected
    }
}

private extension ChipView {
    func getRows(geometry: GeometryProxy) -> [[T]] {
        var rows: [[T]] = []
        var currentRow: [T] = []
        var rowWidth: CGFloat = 0
        let padding: CGFloat = 10
        let maxWidth = geometry.size.width - 40

        for item in options {
            var itemWidth = textWidth(for: "\(item.rawValue)")
            if currentRow.count > 1 {
                itemWidth += padding
            }
            if rowWidth + itemWidth > maxWidth {
                rows.append(currentRow)
                currentRow = [item]
                rowWidth = itemWidth
            } else {
                currentRow.append(item)
                rowWidth += itemWidth
            }
        }
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        return rows
    }

    func textWidth(for text: String) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: UIFont.systemFontSize)
        ]
        let size = (text as NSString).size(withAttributes: attributes)
        return size.width + 50
    }
}
