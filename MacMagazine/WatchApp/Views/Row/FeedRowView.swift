import FeedLibrary
import SwiftUI
import UIComponentsLibrary
import UtilityLibrary

struct FeedRowView: View {
    let post: FeedDB

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                background(size: geometry.size)
                overlayGradient
                content
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func background(size: CGSize) -> some View {
        ZStack {
            Color.black

            if let url = post.artworkRemoteURL {
                CachedAsyncImage(image: url, contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
            } else {
                Color.black.opacity(0.25)
            }
        }
        .frame(width: size.width, height: size.height)
        .clipped()
    }

    private var overlayGradient: some View {
        LinearGradient(
            colors: [
                .black.opacity(0.05),
                .black.opacity(0.80)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var content: some View {
        VStack(spacing: 6) {
            HStack {
                Image("logo_color")
                    .resizable()
                    .scaledToFit()
                Spacer()
            }
            .frame(height: 20)
            .padding(.bottom, 6)

            Text(post.title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(3)
                .padding(.trailing, 22)

            Text(post.dateText)
                .font(.caption2)
                .foregroundStyle(.primary.opacity(0.85))
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)

            Text("Ler mais")
                .font(.caption2)
                .foregroundStyle(.primary.opacity(0.80))
                .frame(maxWidth: .infinity, alignment: .center)
                .lineLimit(1)
                .padding(.top, 6)
                .padding(.bottom, 12)
        }
        .padding(.horizontal, 4)
    }
}

#if DEBUG
#Preview("FeedRowView") {
    FeedRowView(post: .previewItem)
}

#Preview("Feed • Done (com registros)") {
    FeedPreviewHost(status: .done, seedItems: true)
}
#endif
