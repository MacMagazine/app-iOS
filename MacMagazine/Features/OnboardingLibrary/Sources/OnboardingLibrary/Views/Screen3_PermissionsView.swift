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

    // MARK: - Status das permissões

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
//        .background(OnboardingBackground())
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
        VStack(spacing: 16) {
            OnboardingLogoView(width: 80, height: 80)
                .padding(.top, 80)
                .accessibilityHidden(true)

            OnboardingTitleView("Ative as permissões necessárias", animateIn: animateIn)

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
                }
            }
            .frame(maxHeight: .infinity)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    // MARK: - Componentes Compartilhados

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
            Text("Você pode alterar essas permissões a qualquer momento nas Configurações do seu dispositivo.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .onboardingAnimateIn(animateIn, delay: 0.4, reduceMotion: reduceMotion)

            continueButton
                .padding(.bottom, 16)
        }
    }

    private var compactFooterText: some View {
        Text("Altere nas Configurações a qualquer momento.")
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
        .frame(maxWidth: isLandscape ? 200 : .infinity)
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
    @Previewable @Namespace var namespace

    NavigationStack {
        PermissionsView(
            coordinator: OnboardingCoordinator(
                permissionManager: PermissionManager(analytics: AnalyticsManager()),
                analytics: AnalyticsManager()
            ),
            logoNamespace: namespace
        )
    }
}

#Preview("Permissions — Landscape", traits: .landscapeLeft) {
    @Previewable @Namespace var namespace

    NavigationStack {
        PermissionsView(
            coordinator: OnboardingCoordinator(
                permissionManager: PermissionManager(analytics: AnalyticsManager()),
                analytics: AnalyticsManager()
            ),
            logoNamespace: namespace
        )
    }
}
#endif
