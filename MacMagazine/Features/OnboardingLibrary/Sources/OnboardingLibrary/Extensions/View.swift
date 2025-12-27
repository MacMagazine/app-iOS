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

    /// Helper para acessar isLandscape dentro de uma View
    func readIsLandscape(_ binding: Binding<Bool>) -> some View {
        self.modifier(LandscapeReaderModifier(isLandscape: binding))
    }

    var isMac: Bool {
#if os(macOS)
        return true
#else
        return false
#endif
    }

    /// Aplica animação de entrada padrão do onboarding
    /// - Parameters:
    ///   - animateIn: Estado de animação
    ///   - delay: Delay da animação
    ///   - reduceMotion: Se deve respeitar preferência de reduzir movimento
    func onboardingAnimateIn(
        _ animateIn: Bool,
        delay: Double = 0,
        reduceMotion: Bool = false
    ) -> some View {
        self
            .opacity(animateIn ? 1 : 0)
            .offset(y: animateIn ? 0 : (reduceMotion ? 0 : 20))
            .animation(
                reduceMotion ? nil : .easeOut(duration: 0.5).delay(delay),
                value: animateIn
            )
    }

    func onboardingFade(
        _ isVisible: Bool,
        delay: Double = 0,
        duration: Double = 0.6
    ) -> some View {
        modifier(OnboardingFadeModifier(isVisible: isVisible, delay: delay, duration: duration))
    }
}
