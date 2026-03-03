import FeedLibrary
import MacMagazineUILibrary
import SwiftUI
import UtilityLibrary

enum CardLabel {
    case title
    case date
    case author
}

private extension Array where Element == CardLabel {
    func makeText(_ title: String = "Podcast", using data: CardContent) -> String {
        var text = [String]()
        self.forEach {
            switch $0 {
            case .title: text.append(data.title)
            case .date: text.append("publicado \(data.pubDate.toTimeAgoDisplay(showTime: true))")
            case .author:
                if let author = data.author {
                    text.append("por \(author)")
                }
            }
        }
        return title + text.joined(separator: ", ") + "."
    }
}

enum CardButton {
    case share
    case favorite
}

private extension Array where Element == CardButton {
    @MainActor
    func makeButtons(using data: CardContent) -> some View {
        ForEach(self.indices, id: \.self) { index in
            switch self[index] {
            case .favorite:
                FavoriteButton(name: data.title, favorite: data.favorite, action: data.favoriteAction)
            case .share:
                ShareButton(title: data.title, url: data.urlToShare)
            }
        }
    }
}

extension View {
    func cardAccessibility(
        data: CardContent,
        labels: [CardLabel]?,
        buttons: [CardButton]?
    ) -> some View {
        modifier(CardAccessibilityModifier(
            data: data,
            labels: labels ?? [.title, .date],
            buttons: buttons ?? [.favorite, .share])
        )
    }
}

private struct CardAccessibilityModifier: ViewModifier {
    let data: CardContent
    let labels: [CardLabel]
    let buttons: [CardButton]

    func body(content: Content) -> some View {
        content
            .accessibilityElement(children: .ignore)
            .accessibilityChildren {
                Text(labels.makeText(using: data))
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Duplo toque para abrir a notícia.")
                buttons.makeButtons(using: data)
            }
    }
}
