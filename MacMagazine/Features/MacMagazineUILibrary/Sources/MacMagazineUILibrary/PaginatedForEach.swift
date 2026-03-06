import SwiftUI

public struct PaginatedForEach<Element: Identifiable, Content: View>: View {

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

    private var visibleData: [(offset: Int, element: Element)] {
        Array(data.prefix(displayLimit).enumerated())
    }

    private var hasMore: Bool {
        data.count > displayLimit
    }

    public var body: some View {
        ForEach(visibleData, id: \.element.id) { index, item in
            content(index, item)
                .onAppear {
                    let triggerIndex = max(visibleData.count - threshold, 0)
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
