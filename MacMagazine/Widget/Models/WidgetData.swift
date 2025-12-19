import FeedLibrary
import Foundation

extension WidgetData {
    static var placeholder = WidgetData(
        postId: "1122438",
        title: "Apple TV: assista a “O Natal do Charlie Brown” grátis em 13 e 14 de dezembro",
        thumbnail: "https://macmagazine.com.br/wp-content/uploads/2025/12/03-O-Natal-do-Charlie-Brown-1260x709.png",
        pubDate: Date(),
        link: "https://macmagazine.com.br/post/2025/12/03/apple-tv-assista-a-o-natal-do-charlie-brown-gratis-em-13-e-14-de-dezembro/",
        imageData: nil
    )

    var url: URL {
        return URL(staticString: link)
    }
}

extension URL {
    init(staticString string: String) {
        self = URL(string: "\(string)") ?? URL(staticString: "widget://")
    }
}
