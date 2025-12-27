import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

// MARK: - Onboarding Skip Button

public struct OnboardingSkipButton: View {
    let action: () -> Void
    let label: String
    let hint: String

    public init(
        label: String = "Pular introdução",
        hint: String = "Vai direto para a tela de permissões",
        action: @escaping () -> Void
    ) {
        self.label = label
        self.hint = hint
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text("Pular")
                Image(systemName: "chevron.right")
                    .symbolRenderingMode(.hierarchical)
            }
            .font(.body)
            .foregroundColor(.primary)
            .padding()
            .glassEffect()
        }
        .accessibilityLabel(label)
        .accessibilityHint(hint)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Skip Button") {
    OnboardingSkipButton { }
        .padding()
}
#endif
