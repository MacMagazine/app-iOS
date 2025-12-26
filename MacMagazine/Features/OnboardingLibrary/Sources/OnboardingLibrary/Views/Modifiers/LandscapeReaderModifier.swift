import SwiftUI

public struct LandscapeReaderModifier: ViewModifier {
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Binding var isLandscape: Bool

    public func body(content: Content) -> some View {
        content
            .onChange(of: verticalSizeClass) { _, newValue in
                isLandscape = newValue == .compact
            }
            .onAppear {
                isLandscape = verticalSizeClass == .compact
            }
    }
}
