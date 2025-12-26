import SwiftUI

public struct OnboardingLogoView: View {

    let width: CGFloat
    let height: CGFloat

    public init(width: CGFloat = 152,
                height: CGFloat = 152) {
        self.width = width
        self.height = height
    }

    public var body: some View {
        Image("normal", bundle: .module)
            .resizable()
            .scaledToFit()
            .frame(width: self.width, height: self.height)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(.white.opacity(0.15), lineWidth: 1)
            }
            .background {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(.regularMaterial)
                    .shadow(radius: 18, y: 10)
            }
            .accessibilityHidden(true)
    }
}
