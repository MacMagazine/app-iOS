import SwiftUI

public struct ShareButton: View {
    let title: String
    let url: URL?
    let action: (() -> Void)?

    public init(
        title: String,
        url: String,
        action: (() -> Void)? = nil
    ) {
        let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url
        self.url = URL(string: encoded)
        self.title = title
        self.action = action
    }

    public var body: some View {
        if let url {
            ShareLink(item: url, subject: Text(title)) {
                Image(systemName: "square.and.arrow.up")
            }
            .font(.system(size: 15))
            .accessibilityLabel("Compartilhar")
        }
    }
}
