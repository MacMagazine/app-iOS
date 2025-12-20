import SwiftUI

public struct FeaturePageView: View {
    let feature: FeatureContent

    public init(feature: FeatureContent) {
        self.feature = feature
    }

    public var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Icon or image
            Image(systemName: feature.systemImage)
                .font(.system(size: 80))
                .foregroundStyle(.blue.gradient)
                .symbolRenderingMode(.hierarchical)
                .padding(.bottom, 16)
                .accessibilityHidden(true)

            // Title
            Text(feature.title)
                .font(.title.bold())
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
                .accessibilityAddTraits(.isHeader)

            // Description
            Text(feature.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 32)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview

#Preview("Feature Page") {
    FeaturePageView(
        feature: FeatureContent(
            id: 1,
            title: "All new UI",
            description: "Liquid Glass. Fast, easy to use.",
            systemImage: "sparkles"
        )
    )
}
