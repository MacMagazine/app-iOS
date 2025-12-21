import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI

struct FeaturesView: View {
    let coordinator: OnboardingCoordinator
    private let features = FeatureContent.allFeatures

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(features.indices, id: \.self) { index in
                        FeaturePageView(feature: features[index])
                            .tag(index)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(.thinMaterial)
                            )
                            .glassEffect(.regular, in: .rect(cornerRadius: 16))
                            .padding(.horizontal)
                    }
                }
            }
//            .onChange(of: currentPage) { _, newPage in
//                // Track page view
//                coordinator.analytics.track(.buttonTap(
//                    buttonId: AnalyticsConstants.ButtonID.onboardingFeaturePage(newPage + 1).id,
//                    screen: AnalyticsConstants.Screen.onboardingFeatures.name
//                ))
//            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        coordinator.skipToPermissions()
                    }, label: {
                        Image(systemName: "xmark")
                    })
                    .glassEffect(.identity, in: .circle)
                }
            }
            .background(OnboardingBackground())
        }
        .trackScreen(AnalyticsConstants.Screen.onboardingFeatures.name, analytics: coordinator.analytics)
    }
}

// MARK: - Preview

#Preview {
    FeaturesView(
        coordinator: OnboardingCoordinator(
            permissionManager: PermissionManager(analytics: AnalyticsManager()),
            analytics: AnalyticsManager()
        )
    )
}
