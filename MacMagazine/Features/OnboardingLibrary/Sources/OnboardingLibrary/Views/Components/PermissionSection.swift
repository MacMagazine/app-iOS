import SwiftUI
import UIComponentsLibrary

public struct PermissionSection: View {
    let title: String
    let icon: String
    let description: String
    let onContinue: () async -> Void
    let onSkip: (() -> Void)?

    @State private var isProcessing = false

    public init(
        title: String,
        icon: String,
        description: String,
        onContinue: @escaping () async -> Void,
        onSkip: (() -> Void)? = nil
    ) {
        self.title = title
        self.icon = icon
        self.description = description
        self.onContinue = onContinue
        self.onSkip = onSkip
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.blue)
                    .accessibilityHidden(true)

                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            .accessibilityElement(children: .combine)

            // Description
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            // Action buttons
            HStack(spacing: 12) {
                if let onSkip = onSkip {
                    OnboardingButton(title: "Skip", style: .secondary) {
                        onSkip()
                    }
                }

                OnboardingButton(title: "Continue", style: .primary) {
                    isProcessing = true
                    Task {
                        await onContinue()
                        isProcessing = false
                    }
                }
                .disabled(isProcessing)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .glassEffect(.regular, in: .rect(cornerRadius: 16))
    }
}

// MARK: - Preview

#Preview("Permission Section") {
    VStack {
        PermissionSection(
            title: "Push Notifications",
            icon: "bell.badge.fill",
            description: "Enable notifications to get instant alerts for breaking news and sync your preferences across all your devices via iCloud.",
            onContinue: {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            },
            onSkip: {
                print("Skipped")
            }
        )
    }
    .padding()
}
