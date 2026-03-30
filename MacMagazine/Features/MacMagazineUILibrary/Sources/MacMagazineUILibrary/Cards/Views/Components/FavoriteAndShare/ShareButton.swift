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
        self.url = url
        self.title = title
        self.action = action
    }

    public var body: some View {
        UtilityLibrary.ShareButton(title: title, url: url)
            .font(.system(size: 15))
            .simultaneousGesture(TapGesture().onEnded {
                action?()
            })
    }
}
