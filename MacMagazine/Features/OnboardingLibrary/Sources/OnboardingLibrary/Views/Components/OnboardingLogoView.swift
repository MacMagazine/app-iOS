import SwiftUI

public struct OnboardingLogoView: View {

    let width: CGFloat
    let height: CGFloat

    private var cornerRadius: CGFloat {
        min(width, height) * 0.184
    }

    public init(
        width: CGFloat = 152,
        height: CGFloat = 152
    ) {
        self.width = width
        self.height = height
    }

    public var body: some View {
        Image("normal", bundle: .module)
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(.white.opacity(0.15), lineWidth: 1)
            }
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.regularMaterial)
                    .shadow(radius: 8, y: 8)
            }
            .accessibilityHidden(true)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Logo Sizes") {
    VStack(spacing: 40) {
        OnboardingLogoView(width: 152, height: 152)
        OnboardingLogoView(width: 80, height: 80)
        OnboardingLogoView(width: 60, height: 60)
    }
    .padding()
    .background(Color.gray.opacity(0.3))
}
#endif
