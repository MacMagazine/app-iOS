import MacMagazineLibrary
import SwiftUI

public struct NewsCard: View {
    let data: CardContent
    let onSelect: () -> Void

    public init(
        data: CardContent,
        onSelect: @escaping () -> Void
    ) {
        self.data = data
        self.onSelect = onSelect
    }

    public var body: some View {
        Button(action: { onSelect() },
               label: { content })
        .buttonStyle(.plain)
    }
}

private extension NewsCard {
    @ViewBuilder
    var content: some View {
        if let style = data.type.style {
            CardView(data: data, style: style)
        } else if let mostRelevantStyle = data.type.categories.mostRelevant.style {
            CardView(data: data, style: mostRelevantStyle)
        } else {
            CardView(data: data, style: .simple)
        }
    }
}

#if DEBUG
#Preview {
    ZStack {
        Color.brown.ignoresSafeArea()
        VStack {
            NewsCard(data: ContentPreview.appletv) {}
                .padding(.horizontal)

            NewsCard(data: ContentPreview.video) {}
                .padding(.horizontal)

            NewsCard(data: ContentPreview.podcast) {}
                .padding(.horizontal)
        }
    }
}
#endif
