import FeedLibrary
import SwiftUI
import WatchKit

struct FeedRootView: View {

    // MARK: - State

    @StateObject private var viewModel: FeedRootViewModel

    // MARK: - Init

    init(viewModel: FeedRootViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            rootContent
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle {
                    if viewModel.items.isEmpty {
                        Text("MacMagazine")
                            .font(.system(size: 12))
                    }

                    Text("MacMagazine\n\(viewModel.selectedIndex + 1) de \(viewModel.items.count)")
                        .font(.system(size: 12))
                        .frame(alignment: .trailing)
                        .multilineTextAlignment(.trailing)
                        .lineLimit(2)
                        .offset(y: 14)
                }
                .refreshable {
                    await viewModel.refresh()
                }
                .task {
                    if viewModel.items.isEmpty {
                        await viewModel.loadInitial()
                    }
                }
                .navigationDestination(item: $viewModel.selectedPostForDetail) { payload in
                    FeedDetailView(viewModel: viewModel, post: payload.post)
                }
        }
    }

    // MARK: - Root Content

    @ViewBuilder
    private var rootContent: some View {
        switch viewModel.status {
        case .loading:
            ProgressView("Carregando…")

        case .error(let reason):
            errorView(reason: reason)

        case .done:
            if viewModel.items.isEmpty {
                emptyView
            } else {
                carouselFullScreen(items: viewModel.items)
            }
        }
    }

    // MARK: - Full Screen Carousel

    private func carouselFullScreen(items: [FeedDB]) -> some View {
        GeometryReader { geometry in
            let size = geometry.size

            ZStack(alignment: .leading) {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(items.enumerated()), id: \.element.postId) { index, post in
                            FeedFullScreenRowView(post: post)
                                .frame(width: size.width, height: size.height)
                                .id(index)
                                .reportFeedRowPosition(postId: post.postId)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden)
                .contentShape(Rectangle())
                .simultaneousGesture(
                    TapGesture().onEnded {
                        viewModel.toggleActions()
                    }
                )
                .onPreferenceChange(FeedScrollPositionKey.self) { positions in
                    let newIndex = viewModel.computeSelectedIndexByMidY(
                        items: items,
                        positions: positions
                    )

                    if newIndex != viewModel.selectedIndex {
                        viewModel.selectedIndex = newIndex
                        viewModel.hideActions()
                    }
                }
                .overlay(alignment: .bottom) {
                    actionsOverlay(items: items)
                }

                FeedDotsIndicatorView(
                    axis: .vertical,
                    count: items.count,
                    selectedIndex: viewModel.selectedIndex
                )
                .frame(maxHeight: .infinity, alignment: .center)
                .padding(.leading, 6)
                .offset(x: -6)
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Actions Overlay

    private func actionsOverlay(items: [FeedDB]) -> some View {
        Group {
            if viewModel.showActions, let post = currentPost(items: items) {
                HStack(spacing: 10) {
                    Button {
                        viewModel.toggleFavorite(post: post)
                    } label: {
                        Image(systemName: post.favorite ? "star.fill" : "star")
                    }
                    .buttonStyle(.glass)

                    Button("Ver mais") {
                        viewModel.selectedPostForDetail = SelectedPost(post: post)
                    }
                    .buttonStyle(.glass)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .padding(.bottom, 10)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.15), value: viewModel.showActions)
    }

    // MARK: - Helpers

    private func currentPost(items: [FeedDB]) -> FeedDB? {
        guard !items.isEmpty else { return nil }
        let index = viewModel.clampIndex(viewModel.selectedIndex, count: items.count)
        return items[index]
    }

    // MARK: - Shared Views

    private func errorView(reason: String) -> some View {
        VStack(spacing: 10) {
            Text("Não foi possível carregar.")
                .font(.headline)

            Text(reason)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Tentar novamente") {
                Task {
                    await viewModel.refresh()
                }
            }
        }
        .padding()
    }

    private var emptyView: some View {
        VStack(spacing: 8) {
            Text("Sem itens")
                .font(.headline)

            Text("Puxe para atualizar.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Preview

#Preview("Carousel Full Screen") {
    FeedRootView(viewModel: .preview())
}
