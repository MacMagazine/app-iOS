import SwiftUI
import WidgetKit

extension View {
    func overlayHeader() -> some View {
        modifier(OverlayHeaderWidgetModifier())
    }

    func header(title: String) -> some View {
        modifier(HeaderWidgetModifier(title: title))
    }
}

private struct HeaderWidgetModifier: ViewModifier {
    @Environment(\.widgetRenderingMode) var renderingMode
    let title: String

    var logo: String {
        if renderingMode == .accented {
            "logo_white"
        } else {
            "logo_color"
        }
    }

    func body(content: Content) -> some View {
        VStack(spacing: 6) {
            HStack {
                Image(logo)
                    .resizable()
                    .widgetAccentedRenderingMode(.fullColor)
                    .scaledToFit()
                    .frame(width: 30, height: 30)

                Text(title).bold()

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
                VStack(spacing: 6) {
                    HStack {
                        Image(logo)
                            .resizable()
                            .widgetAccentedRenderingMode(.fullColor)
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Spacer()
                    }
                    Spacer()
                }
            }
    }
}
