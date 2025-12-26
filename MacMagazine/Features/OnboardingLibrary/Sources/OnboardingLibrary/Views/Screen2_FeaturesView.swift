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

    // MARK: - Layout Adaptativos

    private var isLandscape: Bool {
        verticalSizeClass == .compact
    }

    private var numberOfColumns: Int {
        if horizontalSizeClass == .regular {
            return 2
        }
        return isLandscape ? 2 : 1
    }

    private var cardsPerPage: Int {
        isLandscape ? 6 : 4
    }

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 16), count: numberOfColumns)
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
            if !isLastPage {
                OnboardingSkipButton(
                    label: "Pular novidades",
                    hint: "Vai direto para a tela de permissões"
                ) {
                    coordinator.skipToPermissions()
                }
                .padding(.top, 16)
                .padding(.trailing, 20)
            }
        }
        .onAppear {
            withAnimation {
                animateIn = true
            }
        }
        .background(OnboardingBackground())
        .trackScreen(AnalyticsConstants.Screen.onboardingFeatures.name, analytics: coordinator.analytics)
    }

    // MARK: - Portrait Layout

    private var portraitLayout: some View {
        VStack(spacing: 16) {
            OnboardingLogoView(width: 80, height: 80)
                .matchedGeometryEffect(id: "onboarding_logo", in: logoNamespace)
                .padding(.top, 80)
                .accessibilityHidden(true)

            OnboardingTitleView("Novidades no App MacMagazine", animateIn: animateIn)

            Spacer(minLength: 16)

            paginatedCardsView

            pageIndicator
                .padding(.top, 8)

            Spacer(minLength: 16)

            footerSection
                .padding(.bottom, 20)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Landscape Layout

    private var landscapeLayout: some View {
        HStack(spacing: 24) {
            VStack(spacing: 12) {
                Spacer()

                OnboardingLogoView(width: 80, height: 80)
                    .matchedGeometryEffect(id: "onboarding_logo", in: logoNamespace)
                    .accessibilityHidden(true)

                Text("Novidades no App")
                    .font(.headline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .opacity(animateIn ? 1 : 0)
                    .accessibilityAddTraits(.isHeader)

                Spacer()

                compactFooterSection
            }
            .frame(maxWidth: 180)
            .padding(.leading, -40)

            VStack(spacing: 12) {
                Spacer()

                paginatedCardsView

                pageIndicator

                Spacer()

                HStack {
                    Spacer()
                    continueButton
                        .opacity(isLastPage ? 1 : 0)
                        .offset(y: isLastPage ? 0 : 20)
                        .animation(.easeInOut(duration: 0.4), value: isLastPage)
                }
            }
            .padding(.top, 40)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    // MARK: - Paginated Cards with Native TabView

    private var paginatedCardsView: some View {
        TabView(selection: $currentPage) {
            ForEach(Array(pages.enumerated()), id: \.offset) { pageIndex, pageCards in
                pageView(cards: pageCards)
                    .tag(pageIndex)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: tabViewHeight)
        .onboardingAnimateIn(animateIn, delay: 0.2, reduceMotion: reduceMotion)
        .accessibilityLabel("Lista de novidades, página \(currentPage + 1) de \(pages.count)")
    }

    private var tabViewHeight: CGFloat {
        if isLandscape {
            return 200
        }
        if horizontalSizeClass == .regular {
            return 280
        }
        return 320
    }

    // MARK: - Custom Page Indicator

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
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .animation(.easeInOut(duration: 0.2), value: currentPage)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Página \(currentPage + 1) de \(pages.count)")
    }

    private func pageView(cards: [OnBoardingFeature]) -> some View {
        LazyVGrid(columns: gridColumns, spacing: 16) {
            ForEach(cards) { card in
                cardView(card: card)
            }
        }
        .padding(.horizontal, 8)
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

    // MARK: - Footer Section

    private var footerSection: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Image(systemName: "person.3.fill")
                    .foregroundStyle(.primary)
                    .accessibilityHidden(true)

                Text("Aqui podemos colocar qualquer texto como a Apple faz.")
                    .font(.caption2)
                    .foregroundStyle(.gray)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            continueButton
        }
        .frame(minHeight: 100)
        .opacity(isLastPage ? 1 : 0)
        .offset(y: isLastPage ? 0 : 30)
        .animation(.easeInOut(duration: 0.4), value: isLastPage)
    }

    private var compactFooterSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(systemName: "person.3.fill")
                .font(.caption)
                .foregroundStyle(.primary)
                .accessibilityHidden(true)

            Text("Aqui podemos colocar qualquer texto como a Apple faz.")
                .font(.caption2)
                .foregroundStyle(.gray)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .opacity(isLastPage ? 1 : 0)
        .offset(y: isLastPage ? 0 : 20)
        .animation(.easeInOut(duration: 0.4), value: isLastPage)
    }

    private var continueButton: some View {
        OnboardingCTAButton("Continuar") {
            handleContinue()
        }
        .onboardingAnimateIn(animateIn, delay: 0.8, reduceMotion: reduceMotion)
        .accessibilityLabel("Continuar para permissões")
        .accessibilityHint("Vai para a tela de permissões")
    }

    // MARK: - Actions

    private func handleContinue() {
        coordinator.navigate(to: .permissions)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Features — Portrait") {
    @Previewable @Namespace var namespace

    NavigationStack {
        FeaturesView(
            coordinator: OnboardingCoordinator(
                permissionManager: PermissionManager(analytics: AnalyticsManager()),
                analytics: AnalyticsManager()
            ),
            logoNamespace: namespace
        )
    }
}

#Preview("Features — Landscape", traits: .landscapeLeft) {
    @Previewable @Namespace var namespace

    NavigationStack {
        FeaturesView(
            coordinator: OnboardingCoordinator(
                permissionManager: PermissionManager(analytics: AnalyticsManager()),
                analytics: AnalyticsManager()
            ),
            logoNamespace: namespace
        )
    }
}
#endif
