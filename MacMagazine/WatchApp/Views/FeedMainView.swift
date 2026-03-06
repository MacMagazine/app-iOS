import FeedLibrary
import StorageLibrary
import SwiftData
import SwiftUI
import WatchKit

struct FeedMainView: View {

    // MARK: - SwiftData

    @Environment(\.modelContext) private var modelContext

    @Query private var items: [FeedDB]

    // MARK: - State

    @State private var viewModel: FeedMainViewModel

    init(viewModel: FeedMainViewModel) {
        _viewModel = State(wrappedValue: viewModel)

        var descriptor = FetchDescriptor<FeedDB>(
            sortBy: [SortDescriptor(\FeedDB.pubDate, order: .reverse)]
        )
        descriptor.fetchLimit = 10
        _items = Query(descriptor)
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            rootContent
                .navigationDestination(item: $viewModel.selectedPostForDetail) { post in
                    FeedDetailView(viewModel: viewModel, post: post)
                }
                .onOpenURL { url in
                    guard url.scheme == "macmagazine", url.host == "news" else { return }

                    let parts = url.pathComponents.filter { $0 != "/" }
                    if parts.count >= 2, parts[0] == "post" {
                        let postId = parts[1]
                        viewModel.openPost(withId: postId, modelContext: modelContext)
                    }
                }
        }
        .task {
            await viewModel.refresh(modelContext: modelContext)
        }
    }

    // MARK: - Root Content

    @ViewBuilder
    private var rootContent: some View {
        switch viewModel.status {
        case .idle: EmptyView()

        case .loading:
            loadingView
                .navigationTitle { navigationTitle("MacMagazine") }

        case let .error(reason):
            errorScreen(reason: reason)

        case .done:
            if items.isEmpty {
                emptyScreen
            } else {
                carouselRowScreen(items: items)
            }
        }
    }

    // MARK: - Navigation Title

    @ViewBuilder
    private func navigationTitle(_ title: String) -> some View {
        Text(title)
            .font(.caption)
            .opacity(viewModel.isRefreshing ? 0 : 1)
            .frame(alignment: .trailing)
            .multilineTextAlignment(.trailing)
            .lineLimit(2)
    }

    // MARK: - Loading

    private var loadingView: some View {
        VStack {
            ProgressView()
            Text("Carregando…")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Error / Empty Screens

    private func errorScreen(reason: String) -> some View {
        statusScreen(
            imageSystemName: "exclamationmark.triangle.fill",
            title: "Algo deu errado",
            message: reason,
            buttonTitle: "Tentar novamente",
            buttonAction: {
                Task {
                    await viewModel.refresh(modelContext: modelContext)
                }
            }
        )
    }

    private var emptyScreen: some View {
        statusScreen(
            imageSystemName: "tray.fill",
            title: "Sem itens",
            message: "Toque abaixo para tentar carregar novamente.",
            buttonTitle: "Atualizar",
            buttonAction: {
                Task {
                    await viewModel.refresh(modelContext: modelContext)
                }
            }
        )
    }

    private func statusScreen(
        imageSystemName: String,
        title: String,
        message: String,
        buttonTitle: String,
        buttonAction: @escaping () -> Void
    ) -> some View {
        ZStack {
            VStack(spacing: 10) {
                Spacer()
                Image(systemName: imageSystemName)
                    .font(.system(size: 28, weight: .semibold))
                    .symbolRenderingMode(.hierarchical)

                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .frame(maxHeight: .infinity, alignment: .center)
        }
        .safeAreaInset(edge: .bottom) {
            Spacer()
            Button(buttonTitle, action: buttonAction)
                .buttonStyle(.glass)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.top, 20)
        }
        .padding(.top, 8)
        .ignoresSafeArea()
    }

    // MARK: - Full Screen Carousel

    private func carouselRowScreen(items: [FeedDB]) -> some View {
        GeometryReader { geometry in
            let size = geometry.size

            ZStack(alignment: .trailing) {
                List {
                    ForEach(Array(items.enumerated()), id: \.element.postId) { index, post in
                        FeedRowView(post: post)
                            .frame(width: size.width, height: size.height)
                            .id(index)
                            .reportFeedRowPosition(postId: post.postId)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .onTapGesture {
                                viewModel.selectedPostForDetail = post
                            }
                            .onLongPressGesture {
                                viewModel.showContextMenu = true
                            }
                    }
                }
                .listStyle(.carousel)
                .scrollIndicators(.hidden)
                .onPreferenceChange(FeedScrollPositionKey.self) { positions in
                    let newIndex = viewModel.computeSelectedIndexByMidY(items: items, positions: positions)
                    if newIndex != viewModel.selectedIndex {
                        viewModel.selectedIndex = newIndex
                    }
                }

                FeedDotsIndicatorView(
                    count: items.count,
                    selectedIndex: viewModel.selectedIndex
                )
                .frame(maxHeight: .infinity, alignment: .trailing)
                .opacity(viewModel.isRefreshing ? 0 : 1)
                .padding(.trailing, 4)
            }
            .overlay {
                if viewModel.isRefreshing {
                    refreshOverlay
                }
            }
            .sheet(isPresented: $viewModel.showContextMenu) {
                contextMenuSheet(items: items)
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Context Menu Sheet

    private func contextMenuSheet(items: [FeedDB]) -> some View {
        Button {
            viewModel.showContextMenu = false
            Task {
                await viewModel.refresh(modelContext: modelContext)
            }
        } label: {
            Label("Atualizar posts", systemImage: "arrow.clockwise")
                .frame(maxWidth: .infinity)
        }
        .glassEffect(.clear)
    }

    // MARK: - Refresh Overlay

    private var refreshOverlay: some View {
        ZStack {
            loadingView
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.black.opacity(0.75))
            )
        }
        .transition(.opacity)
    }

    // MARK: - Helpers

    private func currentPost(items: [FeedDB]) -> FeedDB? {
        guard !items.isEmpty else { return nil }
        let index = viewModel.clampIndex(viewModel.selectedIndex, quantity: items.count)
        return items[index]
    }
}

// MARK: - Preview Support

#if DEBUG
extension FeedMainViewModel {
    static func preview(status: FeedViewModel.Status) -> FeedMainViewModel {
        let database = Database(models: [FeedDB.self], inMemory: true)
        let feedVM = FeedViewModel(storage: database)
        let viewModel = FeedMainViewModel(feedViewModel: feedVM)

        viewModel.setStatusForPreview(status)

        return viewModel
    }
}

struct FeedPreviewHost: View {
    let container: ModelContainer
    let viewModel: FeedMainViewModel

    init(
        status: FeedViewModel.Status,
        seedItems: Bool
    ) {
        let schema = Schema([FeedDB.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            let tmpContainer = try ModelContainer(for: schema, configurations: [config])

            if seedItems {
                for item in FeedDB.previewItems {
                    tmpContainer.mainContext.insert(item)
                }
                try tmpContainer.mainContext.save()
            }

            self.container = tmpContainer
            self.viewModel = .preview(status: status)
        } catch {
            fatalError("Failed to create preview container: \(error)")
        }
    }

    var body: some View {
        FeedMainView(viewModel: viewModel)
            .modelContainer(container)
    }
}

#Preview("Feed • Loading") {
    FeedPreviewHost(status: .loading, seedItems: false)
}

#Preview("Feed • Error") {
    FeedPreviewHost(status: .error(reason: "Sem conexão com a internet."), seedItems: false)
}

#Preview("Feed • Done (sem registros)") {
    FeedPreviewHost(status: .done, seedItems: false)
}

#Preview("Feed • Done (com registros)") {
    FeedPreviewHost(status: .done, seedItems: true)
}
#endif
