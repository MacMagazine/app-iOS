import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

struct WelcomeView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

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
        .containerRelativeFrame([.horizontal, .vertical])
        .overlay(alignment: .topTrailing) {
            OnboardingSkipButton(
                label: "Pular introdução",
                hint: "Vai direto para a tela de permissões"
            ) {
                coordinator.skipToPermissions()
            }
            .padding(.top, 16)
            .padding(.trailing, 20)
        }
//        .background(OnboardingBackground())
        .onAppear { animateIn = true }
        .onDisappear { animateIn = false }
        .trackScreen(
            AnalyticsConstants.Screen.onboardingWelcome.name,
            analytics: coordinator.analytics
        )
    }

    // MARK: - Portrait Layout

    private var portraitLayout: some View {
        VStack(spacing: 0) {
            // Logo fixed at top
            logoView(width: 152, height: 152)
                .padding(.top, 70)
                .onboardingFade(animateIn, delay: 0.00, duration: reduceMotion ? 0 : 0.70)
                .scaleEffect(animateIn ? 1 : (reduceMotion ? 1 : 0.90))
                .animation(reduceMotion ? nil : .easeOut(duration: 0.70), value: animateIn)

            Spacer()

            messageView
                .onboardingFade(animateIn, delay: 0.25, duration: 0.60)

            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            ctaButton
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .onboardingFade(animateIn, delay: 0.95, duration: 0.45)
        }
    }

    // MARK: - Landscape Layout

    private var landscapeLayout: some View {
        HStack(spacing: 32) {
            VStack {
                Spacer()
                logoView(width: 152, height: 152)
                    .padding(.top, -80)
                    .padding(.leading, -50)
                Spacer()
            }
            .frame(maxWidth: 200)

            VStack(spacing: 20) {
                Spacer()

                messageView
                    .onboardingFade(animateIn, delay: 0.25, duration: 0.60)

                Spacer()

                OnboardingCTAButton("Continuar") {
                    trackAndNavigate()
                }
                .onboardingFade(animateIn, delay: 0.95, duration: 0.45)
                .accessibilityLabel("Continuar")
                .accessibilityHint("Avança para ver as novidades do app")
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }

    // MARK: - Shared Components

    private func logoView(width: CGFloat, height: CGFloat) -> some View {
        OnboardingLogoView(width: width, height: height)
            .accessibilityHidden(true)
    }

    private var messageView: some View {
        VStack(spacing: 10) {
            Text("Bem-vindo ao novo app do MacMagazine")
                .font(isLandscape ? .title2.weight(.bold) : .largeTitle.weight(.bold))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)

            Text("Notícias, reviews, vídeos e podcasts em um visual totalmente renovado.")
                .font(isLandscape ? .body : .title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, isLandscape ? 16 : 28)
        .accessibilityElement(children: .combine)
    }

    private var ctaButton: some View {
        OnboardingCTAButton("Continuar") {
            trackAndNavigate()
        }
        .accessibilityLabel("Continuar")
        .accessibilityHint("Avança para ver as novidades do app")
    }

    // MARK: - Actions

    private func trackAndNavigate() {
        coordinator.analytics.track(.buttonTap(
            buttonId: AnalyticsConstants.ButtonID.onboardingWelcomeContinue.id,
            screen: AnalyticsConstants.Screen.onboardingWelcome.name
        ))
        withAnimation(reduceMotion ? nil : .spring(response: 0.7, dampingFraction: 0.85)) {
            coordinator.navigate(to: .features)
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Welcome — Portrait") {
    @Previewable @Namespace var namespace
    WelcomeSheetPreviewHost()
}

#Preview("Welcome — Landscape", traits: .landscapeLeft) {
    @Previewable @Namespace var namespace
    WelcomeSheetPreviewHost()
}

private struct WelcomeSheetPreviewHost: View {
    @State private var isPresented = true
    @State private var coordinator = OnboardingCoordinator(
        permissionManager: PermissionManager(analytics: AnalyticsManager()),
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
