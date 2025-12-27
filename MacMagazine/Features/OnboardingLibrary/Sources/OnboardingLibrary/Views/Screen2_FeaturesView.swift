import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

struct FeaturesView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let coordinator: OnboardingCoordinator
    var logoNamespace: Namespace.ID

    private let features = OnBoardingFeature.allCards

    @State private var animateIn = false
    @State private var currentPage: Int = 0

    // MARK: - Layout Properties

    private var isLandscape: Bool {
        verticalSizeClass == .compact
    }

    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }

    private var numberOfColumns: Int {
        isIPad || isLandscape ? 2 : 1
    }

    private var cardsPerPage: Int {
        isLandscape ? 6 : 4
    }

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: isLandscape ? 12 : 16), count: numberOfColumns)
    }

    private var pages: [[OnBoardingFeature]] {
        features.chunked(into: cardsPerPage)
    }

    private var isLastPage: Bool {
        currentPage >= max(0, pages.count - 1)
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
        .containerRelativeFrame([.horizontal, .vertical])
        .overlay(alignment: .topTrailing) {
            // Skip button - acts like a toolbar
            OnboardingSkipButton(
                label: "Pular novidades",
                hint: "Vá direto para a tela de permissões"
            ) {
                coordinator.skipToPermissions()
            }
            .padding(.top, 16)
            .padding(.trailing, 20)
            .opacity(isLastPage ? 0 : 1)
            .animation(.easeInOut(duration: 0.25), value: isLastPage)
            .allowsHitTesting(!isLastPage)
        }
        //        .background(OnboardingBackground())
        .onAppear { animateIn = true }
        .onDisappear { animateIn = false }
        .trackScreen(AnalyticsConstants.Screen.onboardingFeatures.name, analytics: coordinator.analytics)
    }

    // MARK: - Portrait Layout

    private var portraitLayout: some View {
        VStack(spacing: 0) {
            // Logo fixed at top - same position as WelcomeView
            logoView
                .padding(.top, 70)

            Text("Novidades no app")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .accessibilityAddTraits(.isHeader)
                .padding(.top, 24)

            Spacer()

            paginatedCardsView
                .onboardingFade(animateIn, delay: 0.15, duration: 0.4)

            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            footerSection
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
        }
    }

    // MARK: - Landscape Layout

    private var landscapeLayout: some View {
        HStack(spacing: 20) {
            // Left side - Logo and title
            VStack(spacing: 8) {
                logoView
                Text("Novidades no app")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)
            }
            .frame(width: 120)

            // Right side - Cards and footer
            VStack(spacing: 0) {
                Spacer()

                paginatedCardsView
                    .onboardingFade(animateIn, delay: 0.15, duration: 0.4)

                Spacer()

                // Footer at bottom: dots centered, or dots left + button right
                HStack {
                    if isLastPage {
                        pageIndicator

                        Spacer()

                        OnboardingCTAButton("Continuar") {
                            handleContinue()
                        }
                        .accessibilityLabel("Continuar para permissões")
                        .accessibilityHint("Vá para a tela de permissões")
                    } else {
                        Spacer()
                        pageIndicator
                        Spacer()
                    }
                }
                .padding(.bottom, 8)
                .animation(.easeInOut(duration: 0.3), value: isLastPage)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }

    // MARK: - Logo View

    private var logoView: some View {
        OnboardingLogoView(width: 80, height: 80)
            .accessibilityHidden(true)
    }

    // MARK: - Paginated Cards

    private var paginatedCardsView: some View {
        TabView(selection: $currentPage) {
            ForEach(Array(pages.enumerated()), id: \.offset) { pageIndex, pageCards in
                pageView(cards: pageCards)
                    .tag(pageIndex)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: tabViewHeight)
        .accessibilityLabel("Lista de novidades, página \(currentPage + 1) de \(pages.count)")
    }

    private var tabViewHeight: CGFloat {
        if isLandscape {
            return 200
        }
        if isIPad {
            return 260
        }
        return 300
    }

    private func pageView(cards: [OnBoardingFeature]) -> some View {
        LazyVGrid(columns: gridColumns, spacing: isLandscape ? 8 : 16) {
            ForEach(cards) { card in
                cardView(card: card)
            }
        }
        .padding(.horizontal, isLandscape ? 8 : 16)
    }

    private func cardView(card: OnBoardingFeature) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: card.symbol)
                .font(.title2)
                .foregroundStyle(.primary)
                .symbolVariant(.fill)
                .frame(width: 32)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(card.title)
                    .font(isLandscape ? .subheadline : .title3)
                    .fontWeight(.semibold)

                Text(card.subTitle)
                    .font(isLandscape ? .caption : .subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .accessibilityElement(children: .combine)
    }

    // MARK: - Page Indicator

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<pages.count, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.primary : Color.primary.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(0.2), lineWidth: 0.5)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 1, x: 0, y: 1)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            Capsule()
                .padding()
                .glassEffect(.clear)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .animation(.easeInOut(duration: 0.2), value: currentPage)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Página \(currentPage + 1) de \(pages.count)")
    }

    // MARK: - Footer Section

    private var footerSection: some View {
        VStack(spacing: 16) {
            // Page indicator - centered in bottom area
            pageIndicator

            // CTA button - pushes dots up when appearing
            if isLastPage {
                ctaButton
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isLastPage)
    }

    private var ctaButton: some View {
        OnboardingCTAButton("Continuar") {
            handleContinue()
        }
        .frame(maxWidth: .infinity)
        .accessibilityLabel("Continuar para permissões")
        .accessibilityHint("Vai para a tela de permissões")
    }

    // MARK: - Actions

    private func handleContinue() {
        coordinator.analytics.track(.buttonTap(
            buttonId: AnalyticsConstants.ButtonID.onboardingFeaturesContinue.id,
            screen: AnalyticsConstants.Screen.onboardingFeatures.name
        ))
        withAnimation(reduceMotion ? nil : .spring(response: 0.5, dampingFraction: 0.85)) {
            coordinator.navigate(to: .permissions)
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Features — Portrait") {
    @Previewable @Namespace var namespace
    FeaturesViewSheetPreviewHost()
}

#Preview("Features — Landscape", traits: .landscapeLeft) {
    @Previewable @Namespace var namespace
    FeaturesViewSheetPreviewHost()
}

private struct FeaturesViewSheetPreviewHost: View {
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
