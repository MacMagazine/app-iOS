import SwiftUI

// MARK: - Dots Indicator

public struct FeedDotsIndicatorView: View {
    let count: Int
    let selectedIndex: Int

    public var body: some View {
        VStack(spacing: 5) {
            dots
        }
        .padding(6)
        .allowsHitTesting(false)
    }

    private var dots: some View {
        ForEach(0..<count, id: \.self) { index in
            Circle()
                .fill(dotColor(for: index))
                .frame(width: dotSize(for: index), height: dotSize(for: index))
                .shadow(color: index == selectedIndex ? .white.opacity(0.5) : .clear, radius: 2)
                .animation(.easeInOut(duration: 0.2), value: selectedIndex)
        }
    }

    private func dotColor(for index: Int) -> Color {
        index == selectedIndex ? .white : .white.opacity(0.4)
    }

    private func dotSize(for index: Int) -> CGFloat {
        index == selectedIndex ? 8 : 5
    }
}

#if DEBUG
#Preview {
    ZStack {
        Color.gray
        FeedDotsIndicatorView(count: 10, selectedIndex: 3)
    }
}
#endif
