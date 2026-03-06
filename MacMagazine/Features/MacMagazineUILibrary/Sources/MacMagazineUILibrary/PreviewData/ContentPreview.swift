import Foundation

#if DEBUG
struct ContentPreview {
    @MainActor
    static let video = CardContent(
        type: .video(views: "5,6K", likes: "782", duration: "4:46"),
        title: "Apresento-lhes o… iPhone Pocket?!",
        pubDate: Date(),
        artworkUrl: "https://i.ytimg.com/vi/5rKJeiG-Rug/sddefault.jpg",
        urlToShare: "",
        favorite: true,
        read: false,
        favoriteAction: {},
        readAction: {}
    )

    @MainActor
    static let podcast = CardContent(
        type: .podcast(duration: "45:30"),
        title: "MacMagazine no Ar #123: Especial WWDC 2024",
        pubDate: Date(),
        artworkUrl: "https://macmagazine.com.br/wp-content/uploads/2025/11/28-podcast-1260x709.jpg",
        urlToShare: "",
        favorite: true,
        read: false,
        favoriteAction: {},
        readAction: {}
    )

    @MainActor
    static let appletv = CardContent(
        type: .news(categories: [.appletv], style: .leadingImage),
        title: "Apple TV anuncia série de culinária com Awkwafina, vencedora do Emmy e Globo de Ouro",
        pubDate: Date(),
        artworkUrl: "https://macmagazine.com.br/wp-content/uploads/2025/11/112025_Apple-TV_announces_The_Unlikely_Cook_with_Awkwafina_Big_Image_02-600x400.jpg",
        urlToShare: "",
        favorite: true,
        read: false,
        favoriteAction: {},
        readAction: {}
    )
}
#endif
