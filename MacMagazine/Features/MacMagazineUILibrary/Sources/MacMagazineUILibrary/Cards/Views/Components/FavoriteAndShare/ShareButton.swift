import SwiftUI
import UtilityLibrary

public struct ShareButton: View {
    let title: String
    let url: URL
    let action: (() -> Void)?

    public init?(
        title: String,
        url: String,
        action: (() -> Void)? = nil
    ) {
        guard let url = URL(string: url) else { return nil }
        self.title = title
        self.url = url
        self.action = action
    }

    public var body: some View {
        UtilityLibrary.ShareButton(title: title, url: url)
            .onTapGesture {
                action?()
            }
    }
}
