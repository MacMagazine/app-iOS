import SwiftUI
import UtilityLibrary

public enum CardLabel {
    case title
    case date
    case dateWithTime
    case author
    case duration
}

private extension Array where Element == CardLabel {
    func makeText(_ title: String, using data: CardContent) -> String {
        var text = [String]()
        self.forEach {
            switch $0 {
            case .title: text.append(data.title)
            case .dateWithTime: text.append("publicado \(data.pubDate.toTimeAgoDisplay(showTime: true))")
            case .date: text.append("publicado \(data.pubDate.toTimeAgoDisplay(showTime: false))")
            case .author:
                if let author = data.author {
                    text.append("por \(author)")
                }
            case .duration: text.append("com duração de \(data.type.duration.accessibilityTime)")
            }
        }
        return title + text.joined(separator: ", ") + "."
    }
}

public enum CardButton {
    case read
    case share
    case favorite
}

private extension Array where Element == CardButton {
    @MainActor
    func makeButtons(using data: CardContent) -> some View {
        ForEach(self.indices, id: \.self) { index in
            switch self[index] {
            case .read:
                ReadButton(name: data.title, read: data.read, action: data.readAction)
            case .favorite:
                FavoriteButton(name: data.title, favorite: data.favorite, action: data.favoriteAction)
            case .share:
                ShareButton(title: data.title, url: data.urlToShare)
            }
        }
    }
}

public extension View {
    func cardAccessibility(
        data: CardContent,
        labels: [CardLabel] = [.title, .dateWithTime],
        buttons: [CardButton] = [.favorite, .share],
        hint: String
    ) -> some View {
        modifier(CardAccessibilityModifier(
            data: data,
            labels: labels,
            buttons: buttons,
            hint: hint)
        )
    }
}

private struct CardAccessibilityModifier: ViewModifier {
    let data: CardContent
    let labels: [CardLabel]
    let buttons: [CardButton]
    let hint: String

    func body(content: Content) -> some View {
        content
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text(labels.makeText("", using: data)))
            .accessibilityHint(hint)
            .accessibilityAddTraits(.isButton)
            .accessibilityActions {
                buttons.makeButtons(using: data)
            }
    }
}
