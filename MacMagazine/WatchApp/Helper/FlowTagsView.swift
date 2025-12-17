import SwiftUI

struct FlowTagsView<Tag: Hashable, Content: View>: View {

    // MARK: - Properties

    let tags: [Tag]
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat
    let content: (Tag) -> Content

    @State private var measuredHeight: CGFloat = 0

    // MARK: - Init

    init(
        tags: [Tag],
        horizontalSpacing: CGFloat,
        verticalSpacing: CGFloat,
        @ViewBuilder content: @escaping (Tag) -> Content
    ) {
        self.tags = tags
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.content = content
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { proxy in
            let rows = makeRows(availableWidth: proxy.size.width)

            VStack(alignment: .leading, spacing: verticalSpacing) {
                ForEach(rows.indices, id: \.self) { rowIndex in
                    HStack(spacing: horizontalSpacing) {
                        ForEach(rows[rowIndex], id: \.self) { tag in
                            content(tag)
                                .fixedSize(horizontal: true, vertical: true)
                        }
                    }
                }
            }
            .background(
                GeometryReader { innerProxy in
                    Color.clear
                        .preference(key: HeightPreferenceKey.self, value: innerProxy.size.height)
                }
            )
        }
        .frame(height: measuredHeight)
        .onPreferenceChange(HeightPreferenceKey.self) { height in
            if height != measuredHeight {
                measuredHeight = height
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
    }

    // MARK: - Layout

    private func makeRows(availableWidth: CGFloat) -> [[Tag]] {
        var rows: [[Tag]] = [[]]
        var currentRowWidth: CGFloat = 0

        for tag in tags {
            let tagWidth = estimatedTagWidth(tag: tag)

            if rows[rows.count - 1].isEmpty {
                rows[rows.count - 1].append(tag)
                currentRowWidth = tagWidth
                continue
            }

            let nextWidth = currentRowWidth + horizontalSpacing + tagWidth

            if nextWidth <= availableWidth {
                rows[rows.count - 1].append(tag)
                currentRowWidth = nextWidth
            } else {
                rows.append([tag])
                currentRowWidth = tagWidth
            }
        }

        return rows
    }

    private func estimatedTagWidth(tag: Tag) -> CGFloat {
        let text = String(describing: tag)
        let estimatedCharacterWidth: CGFloat = 6
        let horizontalPadding: CGFloat = 16
        return CGFloat(text.count) * estimatedCharacterWidth + horizontalPadding
    }
}

// MARK: - Height Preference

private struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
