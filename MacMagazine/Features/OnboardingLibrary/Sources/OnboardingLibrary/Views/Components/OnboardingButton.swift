import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

public struct OnboardingButton: View {
    @Environment(\.theme) private var theme: ThemeColor

    let title: String
    let style: ButtonStyle
    let action: () -> Void

    public enum ButtonStyle {
        case primary    // Prominent, filled with gradient
        case secondary  // Clear glass effect
        case skip       // Minimal, text-only
    }

    public init(
        title: String,
        style: ButtonStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.action = action
    }

    public var body: some View {
        switch style {
        case .primary:
            PrimaryButton(
                title,
                style: ButtonStyleConfiguration(color: .white,
                                                stroke: theme.button.primary.color ?? .blue,
                                                fill: theme.button.primary.color ?? .blue),
                action: action
            )

        case .secondary:
            SecondaryButton(title, action: action)

        case .skip:
            TertiaryButton(title, action: action)
        }
    }
}

// MARK: - Preview

#Preview("Button Styles") {
    ZStack {
        Color.brown.ignoresSafeArea()

        VStack(spacing: 20) {
            OnboardingButton(title: "Primary Button", style: .primary) {
                print("Primary tapped")
            }

            OnboardingButton(title: "Secondary Button", style: .secondary) {
                print("Secondary tapped")
            }

            OnboardingButton(title: "Skip", style: .skip) {
                print("Skip tapped")
            }
        }
        .padding()
        .environment(\.theme, ThemeColor())
    }
}
