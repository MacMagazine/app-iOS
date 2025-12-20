import SwiftUI
import WidgetKit

extension View {
    func smallWidgetStyle(image: Image) -> some View {
        modifier(SmallWidgetStyleModifier(image: image))
    }
}

private struct SmallWidgetStyleModifier: ViewModifier {
    @Environment(\.widgetRenderingMode) var renderingMode
    let image: Image

    private var overlayGradient: some View {
        LinearGradient(
            colors: [
                .black.opacity(0.05),
                .black.opacity(0.80)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    func body(content: Content) -> some View {
        if renderingMode == .accented {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .containerBackground(Color.clear, for: .widget)

        } else {
            content
                .background(overlayGradient)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .background(image.resizable().scaledToFill())
                .containerBackground(Color.clear, for: .widget)
                .colorScheme(.dark)
        }
    }
}
