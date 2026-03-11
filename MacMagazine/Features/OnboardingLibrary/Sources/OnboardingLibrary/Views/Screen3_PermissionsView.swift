import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

struct PermissionsView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let coordinator: OnboardingCoordinator
    var logoNamespace: Namespace.ID

    @State private var animateIn = false

    private var isLandscape: Bool {
        verticalSizeClass == .compact
    }

    // MARK: - Permission Status

    private var pushStatus: PermissionCardStatus {
        switch coordinator.permissionManager.currentPushStatus {
        case .notDetermined:
            return .notDetermined
        case .authorized:
            return .granted
        case .denied:
            return .denied
        }
    }

    private var attStatus: PermissionCardStatus {
        switch coordinator.permissionManager.currentATTStatus {
        case .notDetermined:
            return .notDetermined
        case .authorized:
            return .granted
        case .denied, .restricted:
            return .denied
        }
    }

    private var hasInteractedWithPermissions: Bool {
        let pushInteracted = coordinator.permissionManager.currentPushStatus != .notDetermined
        let attInteracted = coordinator.permissionManager.currentATTStatus != .notDetermined

        let showPush = coordinator.permissionManager.shouldShowPushSection || pushInteracted
        let showATT = coordinator.permissionManager.shouldShowATTSection || attInteracted

        if showPush && showATT {
            return pushInteracted && attInteracted
        } else if showPush {
            return pushInteracted
        } else if showATT {
            return attInteracted
        }

        return true
    }

    // MARK: - Body

    var body: some View {
        Group {
            if isLandscape {
                landscapeLayout
            } else {
                portraitLayout
            }
        }
        // .background(OnboardingBackground())
        .onAppear {
            withAnimation {
                animateIn = true
            }
        }
        .task {
            await coordinator.permissionManager.refreshAllPermissionStatuses()
        }
        .trackScreen(AnalyticsConstants.Screen.onboardingPermissions.name, analytics: coordinator.analytics)
    }

    // MARK: - Portrait Layout

    private var portraitLayout: some View {
        VStack(spacing: 0) {
            // Logo fixed at top - same position as other screens
            OnboardingLogoView(width: 80, height: 80)
                .padding(.top, 70)
                .accessibilityHidden(true)

            Text("Ative as permissões necessárias")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .accessibilityAddTraits(.isHeader)
                .padding(.top, 24)

            Spacer()

            permissionCards

            Spacer()

            footerSection
        }
        .padding(.horizontal, 20)
        .containerRelativeFrame([.horizontal, .vertical])
    }

    // MARK: - Landscape Layout

    private var landscapeLayout: some View {
        HStack(spacing: 24) {
            VStack(spacing: 12) {
                OnboardingLogoView(width: 80, height: 80)
                    .accessibilityHidden(true)

                Text("Ative as permissões")
                    .font(.headline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .opacity(animateIn ? 1 : 0)
                    .accessibilityAddTraits(.isHeader)
            }
            .frame(maxWidth: 180, maxHeight: .infinity)
            .padding(.leading, -40)

            VStack(spacing: 16) {
                Spacer()

                permissionCards

                Spacer()

                HStack {
                    compactFooterText
                        .frame(maxWidth: .infinity, alignment: .leading)
                    continueButton
                        .frame(maxWidth: 200)
                }
            }
            .frame(maxHeight: .infinity)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    // MARK: - Shared Components

    private var permissionCards: some View {
        VStack(spacing: isLandscape ? 12 : 16) {
            PermissionCard(
                title: "Notificações",
                icon: "bell.badge.fill",
                description: isLandscape
                ? "Alertas sobre notícias e podcasts."
                : "Receba alertas instantâneos sobre as últimas notícias e podcasts.",
                status: pushStatus,
                onRequest: {
                    await requestPushPermission()
                }
            )
            .onboardingAnimateIn(animateIn, delay: 0.2, reduceMotion: reduceMotion)

            PermissionCard(
                title: "App Analytics",
                icon: "chart.bar.fill",
                description: isLandscape
                ? "Dados anônimos para melhorar o app."
                : "Ajude-nos a melhorar o app com dados anônimos de uso.",
                status: attStatus,
                onRequest: {
                    await requestATTPermission()
                }
            )
            .onboardingAnimateIn(animateIn, delay: 0.3, reduceMotion: reduceMotion)
        }
    }

    private var footerSection: some View {
        VStack(spacing: 12) {
            Text("Você pode alterar essas permissões a qualquer momento nos Ajustes do seu dispositivo.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 340)
                .onboardingAnimateIn(animateIn, delay: 0.4, reduceMotion: reduceMotion)

            continueButton
                .padding(.bottom, 16)
        }
    }

    private var compactFooterText: some View {
        Text("Altere nos Ajustes a qualquer momento.")
            .font(.caption2)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .opacity(animateIn ? 1 : 0)
    }

    private var continueButton: some View {
        OnboardingCTAButton(
            "Continuar",
            isEnabled: hasInteractedWithPermissions
        ) {
            coordinator.completeOnboarding()
        }
        .onboardingAnimateIn(animateIn, delay: 0.5, reduceMotion: reduceMotion)
        .accessibilityLabel("Continuar")
        .accessibilityHint(hasInteractedWithPermissions ? "Finaliza a configuração e abre o app" : "Responda às permissões primeiro")
    }

    // MARK: - Actions

    private func requestPushPermission() async {
        _ = await coordinator.permissionManager.requestPushPermission()
        await coordinator.permissionManager.refreshAllPermissionStatuses()
    }

    private func requestATTPermission() async {
        _ = await coordinator.permissionManager.requestATTPermission()
        await coordinator.permissionManager.refreshAllPermissionStatuses()
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Permissions — Portrait") {
    PermissionViewSheetPreviewHost()
}

#Preview("Permissions — Landscape", traits: .landscapeLeft) {
    PermissionViewSheetPreviewHost()
}

private struct PermissionViewSheetPreviewHost: View {
    @Namespace private var namespace

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
