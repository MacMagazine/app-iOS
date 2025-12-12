import Kingfisher
import SwiftUI
import WidgetKit

extension View {
    func smallWidgetStyle(image: KFImage) -> some View {
        modifier(SmallWidgetStyleModifier(image: image))
    }
}

private struct SmallWidgetStyleModifier: ViewModifier {
    @Environment(\.widgetRenderingMode) var renderingMode
    let image: KFImage

    func body(content: Content) -> some View {
        if renderingMode == .accented {
            content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .containerBackground(Color.clear, for: .widget)

        } else {
            content
            .background(.black.opacity(0.4))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(image.resizable().scaledToFill())
            .containerBackground(Color.clear, for: .widget)
            .colorScheme(.dark)
        }
    }
}
