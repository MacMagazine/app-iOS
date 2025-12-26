import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

struct WelcomeView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    let coordinator: OnboardingCoordinator
    var logoNamespace: Namespace.ID

    @State private var animateIn = false

    private var isLandscape: Bool {
        verticalSizeClass == .compact
    }

    var body: some View {
        Group {
            if isLandscape {
                landscapeLayout
            } else {
                portraitLayout
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                skipButton
            }
        }
        .background(OnboardingBackground())
        .onAppear { animateIn = true }
        .onDisappear { animateIn = false }
        .trackScreen(
            AnalyticsConstants.Screen.onboardingWelcome.name,
            analytics: coordinator.analytics
        )
    }

    // MARK: - Portrait Layout

    private var portraitLayout: some View {
        VStack(spacing: 24) {
            Spacer()

            logoView(width: 152, height: 152)
                .padding(.bottom, 48)

            messageView
                .onboardingFade(animateIn, delay: 0.25, duration: 0.60)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            ctaButton
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .onboardingFade(animateIn, delay: 0.95, duration: 0.45)
        }
    }

    // MARK: - Landscape Layout

    private var landscapeLayout: some View {
        HStack(spacing: 32) {
            // Lado esquerdo: Logo
            VStack {
                Spacer()
                logoView(width: 152, height: 152)
                    .padding(.top, -80)
                    .padding(.leading, -50)
                Spacer()
            }
            .frame(maxWidth: 200)

            // Lado direito: Mensagem e botão
            VStack(spacing: 20) {
                Spacer()

                messageView
                    .onboardingFade(animateIn, delay: 0.25, duration: 0.60)

                Spacer()

                landscapeCtaButton
                    .onboardingFade(animateIn, delay: 0.95, duration: 0.45)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }

    // MARK: - Componentes Compartilhados

    private func logoView(width: CGFloat, height: CGFloat) -> some View {
        OnboardingLogoView(width: width, height: height)
            .matchedGeometryEffect(id: "onboarding_logo", in: logoNamespace)
            .onboardingFade(animateIn, delay: 0.00, duration: 0.70)
            .scaleEffect(animateIn ? 1 : 0.90)
            .animation(.easeOut(duration: 0.70), value: animateIn)
    }

    private var messageView: some View {
        VStack(spacing: 10) {
            Text("Bem-vindo ao novo MacMagazine")
                .font(isLandscape ? .title2.weight(.bold) : .largeTitle.weight(.bold))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)

            Text("Notícias, reviews e podcasts em um visual totalmente renovado.")
                .font(isLandscape ? .body : .title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, isLandscape ? 16 : 28)
    }

    private var skipButton: some View {
        Button { coordinator.skipToPermissions() } label: {
            HStack(spacing: 6) {
                Text("Pular")
                Image(systemName: "chevron.right")
                    .symbolRenderingMode(.hierarchical)
            }
            .font(.body)
        }
        .accessibilityLabel("Pular onboarding")
    }

    private var ctaButton: some View {
        PrimaryButton(
            "Continuar",
            size: 340,
            style: ButtonStyleConfiguration(
                color: .white,
                stroke: theme.button.primary.color ?? .blue,
                fill: theme.button.primary.color ?? .blue
            )
        ) {
            trackAndNavigate()
        }
        .frame(maxWidth: .infinity)
        .accessibilityLabel("Continuar")
    }

    private var landscapeCtaButton: some View {
        Button {
            trackAndNavigate()
        } label: {
            Text("Continuar")
                .textCase(.uppercase)
                .fontWeight(.semibold)
                .font(.subheadline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(theme.button.primary.color ?? .blue)
                .foregroundStyle(.white)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Continuar")
    }

    // MARK: - Actions

    private func trackAndNavigate() {
        coordinator.analytics.track(.buttonTap(
            buttonId: AnalyticsConstants.ButtonID.onboardingWelcomeContinue.id,
            screen: AnalyticsConstants.Screen.onboardingWelcome.name
        ))
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            coordinator.navigate(to: .features)
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Welcome — Portrait") {
    @Previewable @Namespace var namespace

    NavigationStack {
        WelcomeView(
            coordinator: OnboardingCoordinator(
                permissionManager: PermissionManager(analytics: AnalyticsManager()),
                analytics: AnalyticsManager()
            ),
            logoNamespace: namespace
        )
    }
}

#Preview("Welcome — Landscape", traits: .landscapeLeft) {
    @Previewable @Namespace var namespace

    NavigationStack {
        WelcomeView(
            coordinator: OnboardingCoordinator(
                permissionManager: PermissionManager(analytics: AnalyticsManager()),
                analytics: AnalyticsManager()
            ),
            logoNamespace: namespace
        )
    }
}
#endif
