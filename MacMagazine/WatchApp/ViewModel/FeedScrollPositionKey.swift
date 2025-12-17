import SwiftUI
import WatchKit

struct FeedScrollPositionKey: PreferenceKey {
    static var defaultValue: [String: CGPoint] = [:]

    static func reduce(value: inout [String: CGPoint], nextValue: () -> [String: CGPoint]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct FeedRowPositionReporter: ViewModifier {
    let postId: String

    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { proxy in
                    let frame = proxy.frame(in: .global)
                    let point = CGPoint(x: frame.midX, y: frame.midY)

                    Color.clear
                        .preference(
                            key: FeedScrollPositionKey.self,
                            value: [postId: point]
                        )
                }
            }
    }
}

extension View {
    func reportFeedRowPosition(postId: String) -> some View {
        modifier(FeedRowPositionReporter(postId: postId))
    }
}
