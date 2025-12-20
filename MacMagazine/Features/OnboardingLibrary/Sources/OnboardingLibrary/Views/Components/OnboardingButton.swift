import SwiftUI
import UIComponentsLibrary

public struct OnboardingButton: View {
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
            Button(action: action) {
                Text(title)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
            }
            .buttonStyle(PrimaryButtonStyle())

        case .secondary:
            Button(action: action) {
                Text(title)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
            }
            .buttonStyle(SecondaryButtonStyle())

        case .skip:
            Button(action: action) {
                Text(title)
                    .font(.subheadline)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
            }
            .buttonStyle(SkipButtonStyle())
        }
    }
}

// MARK: - Button Styles

private struct PrimaryButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.blue.gradient)
            )
            .glassEffect(.regular, in: .rect(cornerRadius: 16))
            .onTapGesture {
                configuration.trigger()
            }
    }
}

private struct SecondaryButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.primary)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(.primary.opacity(0.2), lineWidth: 1)
            )
            .glassEffect(.clear, in: .rect(cornerRadius: 16))
            .onTapGesture {
                configuration.trigger()
            }
    }
}

private struct SkipButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.secondary)
            .onTapGesture {
                configuration.trigger()
            }
    }
}

// MARK: - Preview

#Preview("Button Styles") {
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
}
