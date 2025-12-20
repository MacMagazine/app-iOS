import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI

struct FeaturesView: View {
    let coordinator: OnboardingCoordinator
    @State private var currentPage = 0

    private let features = FeatureContent.allFeatures

    var body: some View {
        ZStack(alignment: .top) {
            // TabView for pages
            TabView(selection: $currentPage) {
                ForEach(features.indices, id: \.self) { index in
                    FeaturePageView(feature: features[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .onChange(of: currentPage) { _, newPage in
                // Track page view
                coordinator.analytics.track(.buttonTap(
                    buttonId: AnalyticsConstants.ButtonID.onboardingFeaturePage(newPage + 1).id,
                    screen: AnalyticsConstants.Screen.onboardingFeatures.name
                ))
            }

            // Skip button overlay (pages 0-9)
            if currentPage < features.count - 1 {
                VStack {
                    HStack {
                        Spacer()
                        OnboardingButton(title: "Skip", style: .skip) {
                            coordinator.analytics.track(.buttonTap(
                                buttonId: AnalyticsConstants.ButtonID.onboardingFeaturesSkip.id,
                                screen: AnalyticsConstants.Screen.onboardingFeatures.name
                            ))
                            coordinator.navigate(to: .permissions)
                        }
                        .padding(.trailing, 24)
                        .padding(.top, 20)
                    }
                    Spacer()
                }
            }

            // Continue button on last page
            if currentPage == features.count - 1 {
                VStack {
                    Spacer()
                    OnboardingButton(title: "Continue", style: .primary) {
                        coordinator.analytics.track(.buttonTap(
                            buttonId: AnalyticsConstants.ButtonID.onboardingFeaturesContinue.id,
                            screen: AnalyticsConstants.Screen.onboardingFeatures.name
                        ))
                        coordinator.navigate(to: .permissions)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .background(OnboardingBackground())
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
