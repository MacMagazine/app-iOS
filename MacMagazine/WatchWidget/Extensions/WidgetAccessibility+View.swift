import SwiftUI
import WidgetKit

private enum WidgetAccessibility {
    static let label = "MacMagazine"
    static let hint  = "Toque para abrir as notícias"
}

// MARK: - Generic (inline / corner)

extension View {

    func macMagazineWidgetAccessibility(
        url: URL?,
        lastPostTitle: String,
        children: AccessibilityChildBehavior? = nil
    ) -> some View {
        Group {
            if let children {
                self
                    .accessibilityElement(children: children)
                    .accessibilityLabel(WidgetAccessibility.label)
                    .accessibilityValue("Última notícia: \(lastPostTitle)")
                    .accessibilityHint(WidgetAccessibility.hint)
            } else {
                self
                    .accessibilityLabel(WidgetAccessibility.label)
                    .accessibilityValue("Última notícia: \(lastPostTitle)")
                    .accessibilityHint(WidgetAccessibility.hint)
            }
        }
        .widgetURL(url)
    }

    // MARK: - Circular

    func macMagazineCircular(
        url: URL?
    ) -> some View {
        self
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(WidgetAccessibility.label)
            .accessibilityValue("Abrir notícias")
            .accessibilityHint("Toque para abrir")
            .widgetURL(url)
    }

    // MARK: - Rectangular

    func macMagazineRectangular(
        url: URL?,
        accessibilityValue: String
    ) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel(WidgetAccessibility.label)
            .accessibilityValue(accessibilityValue)
            .accessibilityHint(WidgetAccessibility.hint)
            .widgetURL(url)
    }
}
