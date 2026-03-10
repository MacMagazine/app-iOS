import MacMagazineLibrary
import SwiftUI

public struct NewsCard: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

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
    }
}

private extension NewsCard {
    @ViewBuilder
    var content: some View {
        if dynamicTypeSize.usesPrimaryCardLayout {
            switch data.type.categories.mostRelevant.style {
            case .leadingImage: LeadingImageCard(data: data)
            case .highlight, .glass: GlassCardView(data: data)
            case .none:
                switch data.type.style {
                case .leadingImage, .none: LeadingImageCard(data: data)
                case .highlight, .glass: GlassCardView(data: data)
                }
            }
        } else {
            LeadingImageCard(data: data)
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
