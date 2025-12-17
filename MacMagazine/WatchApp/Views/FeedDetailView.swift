import FeedLibrary
import SwiftUI

struct FeedDetailView: View {

    // MARK: - Properties

    let post: FeedDB

    @StateObject private var viewModel: FeedRootViewModel

    // MARK: - Init

    init(viewModel: FeedRootViewModel, post: FeedDB) {
        self.post = post
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                header
                categories
                bodyText
                footer
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .navigationTitle("Notícia")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(post.title)
                .font(.headline)
                .bold()
                .lineLimit(3)

            Text(post.dateText)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Categories (Flow Tags)

    @ViewBuilder
    private var categories: some View {
        if !post.categories.isEmpty {
            FlowTagsView(
                tags: post.categories.map { $0.uppercased() },
                horizontalSpacing: 6,
                verticalSpacing: 6
            ) { tag in
                Text(tag)
                    .font(.caption2)
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.secondary.opacity(0.4))
                    .clipShape(Capsule())
            }
            .allowsHitTesting(false)
        }
    }

    // MARK: - Body

    @ViewBuilder
    private var bodyText: some View {
        if let content = post.displayBody {
            Divider()
                .padding(.vertical, 4)

            Text(content)
                .font(.body)
                .multilineTextAlignment(.leading)
        }
    }

    // MARK: - Footer

    private var footer: some View {
        VStack(spacing: 8) {
            Divider()
                .padding(.top, 4)

            Button {
                viewModel.toggleFavorite(post: post)
            } label: {
                Image(systemName: post.favorite ? "star.fill" : "star")
            }
            .buttonStyle(.glass)
        }
    }
}

// MARK: - Preview
#if DEBUG
#Preview {
    FeedDetailView(viewModel: .preview(), post: .previewItem)
}
#endif
