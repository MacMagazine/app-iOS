import MacMagazineLibrary
import SwiftUI

public struct NewsCardView: View {
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

private extension NewsCardView {
    @ViewBuilder
    var content: some View {
        switch data.type.category.style {
        case .leadingImage: LeadingImageView(data: data)
        case .topImage: EmptyView()
        case .bottomImage: EmptyView()
        case .highlight: EmptyView()
        case .simple: EmptyView()
        case .glass: GlassCardView(data: data)
        }
    }
}

#if DEBUG
#Preview {
    ZStack {
        Color.brown.ignoresSafeArea()
        VStack {
            NewsCardView(data: ContentPreview.appletv) {}
                .padding(.horizontal)

            NewsCardView(data: ContentPreview.video) {}
                .padding(.horizontal)

            NewsCardView(data: ContentPreview.podcast) {}
                .padding(.horizontal)
        }
    }
}
#endif
