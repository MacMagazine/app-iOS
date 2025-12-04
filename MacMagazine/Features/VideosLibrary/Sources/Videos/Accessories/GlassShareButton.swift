import SwiftUI
import StorageLibrary
import YouTubeLibrary

public struct GlassShareButton: View {
    let content: VideoDB
    let tint: Color?

    public init(content: VideoDB, tint: Color? = nil) {
        self.content = content
        self.tint = tint
    }

    public var body: some View {
        ShareButton(content: content)
            .buttonStyle(.plain)
            .font(.system(size: 16))
            .frame(width: 35, height: 35)
            .glassEffect()
            .applyTint(tint)
    }
}
