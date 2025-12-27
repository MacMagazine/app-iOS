import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

// MARK: - Onboarding CTA Button

public struct OnboardingCTAButton: View {
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    let title: String
    let showChevron: Bool
    let isEnabled: Bool
    let action: () -> Void

    private var isLandscape: Bool {
        verticalSizeClass == .compact
    }

    public init(
        _ title: String,
        showChevron: Bool = false,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.showChevron = showChevron
        self.isEnabled = isEnabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .textCase(.uppercase)
                    .fontWeight(.bold)
                    .font(isLandscape ? .subheadline : .body)

                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.subheadline.weight(.semibold))
                }
            }
            .frame(maxWidth: isLandscape ? 160 : .infinity)
            .padding(.vertical, isLandscape ? 12 : 16)
            .background(isEnabled ? (theme.button.primary.color ?? .blue) : Color.gray.opacity(0.5))
            .foregroundStyle(.white)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("CTA Buttons") {
    VStack(spacing: 20) {
        OnboardingCTAButton("Continuar") { }

        OnboardingCTAButton("Avançar", showChevron: true) { }

        OnboardingCTAButton("Desabilitado", isEnabled: false) { }
    }
    .padding()
}
#endif
