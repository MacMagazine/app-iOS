import FeedLibrary
import SwiftUI

struct FeedDetailView: View {

    @Environment(\.modelContext) private var modelContext

    // MARK: - Properties

    let post: FeedDB

    @State private var viewModel: FeedMainViewModel

    // MARK: - Init

    init(viewModel: FeedMainViewModel, post: FeedDB) {
        self.post = post
        _viewModel = State(wrappedValue: viewModel)
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                header
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
                viewModel.toggleFavorite(post: post, modelContext: modelContext)
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
    FeedDetailView(viewModel: .preview(status: .done),
                   post: .previewItem)
}
#endif
