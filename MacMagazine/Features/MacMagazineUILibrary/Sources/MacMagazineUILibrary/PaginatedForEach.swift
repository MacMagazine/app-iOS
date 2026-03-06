import SwiftUI

/// A paginated `ForEach` that renders items in batches, loading more as the user scrolls.
///
/// Use the `.id()` modifier to reset pagination when filters change:
/// ```swift
/// PaginatedForEach(items) { index, item in
///     CardView(item)
/// }
/// .id(filterValue)
/// ```
public struct PaginatedForEach<Element, Content: View>: View {

    private let data: [Element]
    private let pageSize: Int
    private let threshold: Int
    private let content: (Int, Element) -> Content

    @State private var displayLimit: Int

    public init(
        _ data: [Element],
        pageSize: Int = 30,
        threshold: Int = 5,
        @ViewBuilder content: @escaping (Int, Element) -> Content
    ) {
        self.data = data
        self.pageSize = pageSize
        self.threshold = threshold
        self.content = content
        _displayLimit = State(initialValue: pageSize)
    }

    private var displayedCount: Int {
        min(displayLimit, data.count)
    }

    private var hasMore: Bool {
        data.count > displayLimit
    }

    public var body: some View {
        ForEach(0..<displayedCount, id: \.self) { index in
            content(index, data[index])
                .onAppear {
                    let triggerIndex = max(displayedCount - threshold, 0)
                    if index == triggerIndex {
                        loadMore()
                    }
                }
        }
        if hasMore {
            ProgressView()
                .frame(maxWidth: .infinity)
                .padding()
        }
    }

    private func loadMore() {
        guard hasMore else { return }
        displayLimit += pageSize
    }
}
