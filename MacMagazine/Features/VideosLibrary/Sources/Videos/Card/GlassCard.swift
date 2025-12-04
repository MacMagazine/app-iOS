import SwiftUI
import StorageLibrary
import YouTubeLibrary

@MainActor
public struct GlassCard: VideoCard {
    public let buttonColor: Color?
    
    public init(buttonColor: Color? = nil) {
        self.buttonColor = buttonColor
    }
    
    public func makeBody(data: VideoDB) -> some View {
        GlassCardView(data: data, buttonColor: buttonColor)
    }
}
