import FeedLibrary
import SwiftData
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct FavoriteButton: View {
    @Environment(\.modelContext) private var context

    @Bindable var content: PodcastDB

    public var body: some View {
        Button(action: {
            content.favorite.toggle()
            try? context.save()
            #if canImport(UIKit)
            UIAccessibility.post(
                notification: .announcement,
                argument: content.favorite ? "Podcast favoritado." : "Podcast não favoritado."
            )
            #endif

        }, label: {
            Image(systemName: "star\(content.favorite ? ".fill" : "")")
        })
        .accessibilityLabel("Favoritar o podcast.")
        .accessibilityValue(content.favorite ? "Favoritado." : "Não favoritado.")
    }
}
