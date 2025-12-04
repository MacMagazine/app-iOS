import YouTubeLibrary
import SwiftUI

public extension VideoDB {
    var formattedDateShort: String {
        pubDate.formattedDate(using: "dd/MM/yy")
    }
    
    var viewsText: String {
        "\(views.formattedBigNumber) visualizações"
    }
    
    var likesText: String {
        "\(likes.formattedBigNumber) curtidas"
    }
}
