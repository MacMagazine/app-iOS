import SwiftUI
import WidgetKit

extension View {
    func overlayHeader() -> some View {
        modifier(OverlayHeaderWidgetModifier())
    }

    func header(title: String, spacing: CGFloat) -> some View {
        modifier(HeaderWidgetModifier(title: title, spacing: spacing))
    }
}

private struct HeaderWidgetModifier: ViewModifier {
    @Environment(\.widgetRenderingMode) var renderingMode
    let title: String
    let spacing: CGFloat

    var logo: String {
        if renderingMode == .accented {
            "macmagazine_clear"
        } else {
            "macmagazine"
        }
    }

    func body(content: Content) -> some View {
        VStack(spacing: spacing) {
            HStack(spacing: 0) {
                Image(logo)
                    .resizable()
                    .widgetAccentedRenderingMode(.fullColor)
                    .scaledToFit()
                    .frame(height: 20)
                Spacer()
            }
            content
        }
        .padding()
    }
}

private struct OverlayHeaderWidgetModifier: ViewModifier {
    @Environment(\.widgetRenderingMode) var renderingMode

    var logo: String {
        if renderingMode == .accented {
            "logo_white"
        } else {
            "logo_color"
        }
    }

    func body(content: Content) -> some View {
        content
            .padding()
            .overlay {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer()
                        Image(logo)
                            .resizable()
                            .widgetAccentedRenderingMode(.fullColor)
                            .scaledToFit()
                            .frame(width: 30)
                    }
                    Spacer()
                }
                .padding()
            }
    }
}
