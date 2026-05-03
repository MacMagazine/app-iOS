import SwiftUI
import UtilityLibrary

public struct ShareButton: View {
    let title: String
    let url: URL

    public init?(
        title: String,
        url: String,
    ) {
        guard let url = URL(string: url) else { return nil }
        self.url = url
        self.title = title
    }

    public var body: some View {
        UtilityLibrary.ShareButton(title: title, url: url)
            .padding(10)
            .contentShape(Circle())
            .font(.system(size: 15))
    }
}
