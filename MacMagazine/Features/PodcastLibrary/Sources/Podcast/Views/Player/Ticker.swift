import SwiftUI

struct Ticker: View {
    let text: String
    let speed: Double

    @State private var textWidth: CGFloat = 0
    @State private var startTime: Date = .now

    var body: some View {
        TimelineView(.animation) { timeline in
            GeometryReader { geometry in
                Text(text)
                    .font(.body)
                    .lineLimit(1)
                    .fixedSize()
                    .frame(height: geometry.size.height)
                    .offset(x: calculateOffset(for: timeline.date))
                    .onAppear { update() }
                    .onChange(of: text) { _, _ in update() }
            }
            .clipped()
            .mask {
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .black, location: 0.05),
                        .init(color: .black, location: 0.95),
                        .init(color: .clear, location: 1)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            }
        }
    }
}

private extension Ticker {
    func update() {
        textWidth = text.size(withAttributes: [.font: UIFont.preferredFont(forTextStyle: .body)]).width
        startTime = .now
    }

    func calculateOffset(for date: Date) -> CGFloat {
        guard textWidth > 0 else { return 0 }
        let duration = textWidth / speed
        let elapsed = date.timeIntervalSince(startTime).truncatingRemainder(dividingBy: duration)
        let progress = elapsed / duration
        return -textWidth * progress
    }
}
