import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI

public struct OnboardingContainerView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var coordinator: OnboardingCoordinator
    @Namespace private var logoAnimation

    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }

    public init(coordinator: OnboardingCoordinator) {
        _coordinator = State(initialValue: coordinator)
    }

    public var body: some View {
        NavigationStack {
            ZStack {
//                OnboardingBackground()

                Group {
                    switch coordinator.currentScreen {
                    case .welcome:
                        WelcomeView(coordinator: coordinator, logoNamespace: logoAnimation)
                    case .features:
                        FeaturesView(coordinator: coordinator, logoNamespace: logoAnimation)
                    case .permissions:
                        PermissionsView(coordinator: coordinator, logoNamespace: logoAnimation)
                    }
                }
                .transition(.opacity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .environment(\.theme, theme)
        .shadow(color: .black.opacity(isIPad ? 0.3 : 0), radius: 30, x: 0, y: 10)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Sheet - Portrait") {
    OnboardingSheetPreviewHost()
}

#Preview("Sheet - Landscape", traits: .landscapeLeft) {
    OnboardingSheetPreviewHost()
}

private struct OnboardingSheetPreviewHost: View {
    @State private var isPresented = true
    @State private var coordinator = OnboardingCoordinator(
        permissionManager: PermissionManager(analytics: AnalyticsManager(), pushNotification: PushNotification()),
        analytics: AnalyticsManager()
    )

    var body: some View {
        ZStack {
            Color.gray.opacity(0.12)
                .ignoresSafeArea()

            Text("MainView (simulação)")
                .font(.headline)
        }
        .sheet(isPresented: $isPresented) {
            OnboardingContainerView(coordinator: coordinator)
                .environment(\.theme, ThemeColor())
                .presentationDetents([.large])
                .interactiveDismissDisabled(true)
        }
        .onAppear {
            isPresented = true
        }
    }
}
#endif
