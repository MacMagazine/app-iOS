// TODO: Migrate to the CollectionView component located in Libraries
import SwiftUI
import UIComponentsLibrary

// MARK: - Collection View With Header

/// CollectionView with optional header support
/// Header appears above the grid and scrolls with the content
public struct CollectionViewWithHeader<Header: View, Content: View>: View {

    // MARK: - Properties

    @State private var cardWidth = CGFloat.zero
    @Binding var scrollPosition: ScrollPosition

    private let title: String
    private let status: APIStatus
    private let usesDensity: Bool
    private var favorite: Bool
    private var isSearching: Bool
    private var quantity: Int
    private var density: CardDensity { .density(using: cardWidth) }

    private let header: (() -> Header)?
    private let retryAction: (() -> Void)?
    private let content: () -> Content

    private let grid = GridItem(
        .adaptive(minimum: 280),
        spacing: 20,
        alignment: .top
    )

    // MARK: - Initialization

    public init(
        title: String,
        status: APIStatus,
        usesDensity: Bool = true,
        scrollPosition: Binding<ScrollPosition>,
        favorite: Bool = false,
        isSearching: Bool = false,
        quantity: Int = 0,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content,
        retryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.status = status
        self.usesDensity = usesDensity
        self.favorite = favorite
        self.isSearching = isSearching
        self.quantity = quantity
        self.header = header
        self.content = content
        self.retryAction = retryAction

        _scrollPosition = scrollPosition
    }

    // MARK: - Body

    public var body: some View {
        VStack {
            LoadingAndErrorView(
                title: title,
                status: status,
                favorite: favorite,
                isSearching: isSearching,
                quantity: quantity,
                retryAction: retryAction
            )

            ScrollView {
                VStack(spacing: 20) {
                    // Header (full width, outside grid)
                    if let header {
                        header()
                    }

                    // Grid content
                    LazyVGrid(
                        columns: Array(repeating: grid, count: usesDensity ? density.columns : 1),
                        spacing: 20
                    ) {
                        content()
                    }
                    .padding(.horizontal)
                }
            }
            .scrollPosition($scrollPosition)
        }
        .cardSize { value in
            cardWidth = value
        }
    }
}

// MARK: - Convenience Init (No Header)

extension CollectionViewWithHeader where Header == EmptyView {
    public init(
        title: String,
        status: APIStatus,
        usesDensity: Bool = true,
        scrollPosition: Binding<ScrollPosition>,
        favorite: Bool = false,
        isSearching: Bool = false,
        quantity: Int = 0,
        @ViewBuilder content: @escaping () -> Content,
        retryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.status = status
        self.usesDensity = usesDensity
        self.favorite = favorite
        self.isSearching = isSearching
        self.quantity = quantity
        self.header = nil
        self.content = content
        self.retryAction = retryAction

        _scrollPosition = scrollPosition
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    CollectionViewWithHeader(
        title: "Notícias",
        status: .done,
        scrollPosition: .constant(ScrollPosition()),
        header: {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.3))
                .frame(height: 200)
                .overlay(Text("Header"))
        },
        content: {
            ForEach(0..<10, id: \.self) { index in
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 150)
                    .overlay(Text("Card \(index)"))
            }
        }
    )
}
#endif
