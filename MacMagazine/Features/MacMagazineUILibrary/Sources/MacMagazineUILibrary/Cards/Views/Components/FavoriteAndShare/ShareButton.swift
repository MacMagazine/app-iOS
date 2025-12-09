import SwiftUI
import UtilityLibrary

public struct ShareButton: View {
    let title: String
    let url: String

    public init(
        title: String,
        url: String
    ) {
        self.title = title
        self.url = url
    }

    public var body: some View {
        if let url = URL(string: url) {
            UtilityLibrary.ShareButton(title: title, url: url)
        }
    }
}
