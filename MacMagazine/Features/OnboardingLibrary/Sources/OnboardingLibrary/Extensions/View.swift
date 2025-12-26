import SwiftUI

public extension View {

    @ViewBuilder
    func blurSlide(_ show: Bool) -> some View {
        self
            .compositingGroup()
            .blur(radius: show ? 0 : 10)
            .opacity(show ? 1 : 0)
            .offset(y: show ? 0 : 100)
    }

    @ViewBuilder
    func setUpOnBoarding() -> some View {
        #if os(macOS)
        self
            .padding(.horizontal, 20)
            .frame(minHeight: 600)
        #else
        if UIDevice.current.userInterfaceIdiom == .pad {
            self
                .presentationSizing(.fitted)
                .padding(.horizontal, 25)
        } else {
            self
        }
        #endif
    }

    var isMac: Bool {
        #if os(macOS)
        return true
        #else
        return false
        #endif
    }
}
