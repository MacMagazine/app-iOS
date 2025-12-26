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

    private var isFirstPage: Bool {
        currentPage == 0
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
        .padding(.horizontal, 20)
        .containerRelativeFrame([.horizontal, .vertical])
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { value in
                    let horizontal = value.translation.width

                    if horizontal > 0 && !isFirstPage {
                        withAnimation(.smooth) {
                            currentPage -= 1
                        }
                    } else if horizontal < 0 && !isLastPage {
                        withAnimation(.smooth) {
                            currentPage += 1
                        }
                    }
                }
        )
        .overlay(alignment: .topTrailing) {
            if !isLastPage {
                skipButton
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
                .padding(.top, 80)

            titleView

            Spacer()

            cardsGrid

            Spacer()

            footerSection
        }
    }

    // MARK: - Landscape Layout

    private var landscapeLayout: some View {
        HStack(spacing: 24) {
            // Lado esquerdo: Logo e título (centralizado verticalmente)
            VStack(spacing: 12) {
                Spacer()

                OnboardingLogoView(width: 80, height: 80)

                Text("Novidades no App")
                    .font(.headline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .opacity(animateIn ? 1 : 0)

                Spacer()

                compactFooterSection
            }
            .frame(maxWidth: 180)
            .padding(.leading, -40)

            // Lado direito: Cards e navegação
            VStack(spacing: 12) {
                Spacer()

                cardsGrid

                Spacer()

                HStack {
                    if pages.count > 1 {
                        pageIndicator
                    }

                    Spacer()

                    buttonsRow
                }
            }
            .padding(.top, 40)
        }
        .padding(.vertical, 16)
    }

    // MARK: - Componentes Compartilhados

    private var skipButton: some View {
        Button { coordinator.skipToPermissions() } label: {
            HStack(spacing: 6) {
                Text("Pular")
                Image(systemName: "chevron.right")
                    .symbolRenderingMode(.hierarchical)
            }
            .font(.body)
            .foregroundColor(.primary)
            .padding()
            .glassEffect(.clear.interactive())
        }
        .accessibilityLabel("Pular novidades")
        .accessibilityHint("Vai direto para a tela de permissões")
    }

    private var titleView: some View {
        Text("Novidades no App MacMagazine")
            .font(.title2)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .opacity(animateIn ? 1 : 0)
            .offset(y: animateIn ? 0 : (reduceMotion ? 0 : 20))
            .animation(reduceMotion ? nil : .easeOut(duration: 0.5).delay(0.1), value: animateIn)
            .accessibilityAddTraits(.isHeader)
    }

    private var cardsGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: 16) {
            let pageCards = pages.count > 1 ? pages[currentPage] : features

            ForEach(Array(pageCards.enumerated()), id: \.offset) { index, card in
                cardView(card: card, index: index)
            }
        }
        .accessibilityLabel("Lista de novidades, página \(currentPage + 1) de \(pages.count)")
    }

    private func cardView(card: OnBoardingFeature, index: Int) -> some View {
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
        .opacity(animateIn ? 1 : 0)
        .offset(y: animateIn ? 0 : (reduceMotion ? 0 : 20))
        .animation(reduceMotion ? nil : .easeOut(duration: 0.5).delay(0.2 + Double(index) * 0.1), value: animateIn)
        .accessibilityElement(children: .combine)
    }

    private var pageIndicator: some View {
        HStack(spacing: 6) {
            ForEach(0..<pages.count, id: \.self) { index in
                Circle()
                    .frame(width: 6, height: 6)
                    .foregroundStyle(.primary)
                    .opacity(index == currentPage ? 1 : 0.25)
                    .animation(.smooth, value: currentPage)
            }
        }
        .opacity(animateIn ? 1 : 0)
        .animation(reduceMotion ? nil : .easeOut(duration: 0.5).delay(0.6), value: animateIn)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Página \(currentPage + 1) de \(pages.count)")
    }

    private var footerSection: some View {
        VStack(spacing: 12) {
            if pages.count > 1 {
                pageIndicator
            }

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
            .opacity(animateIn ? 1 : 0)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.5).delay(0.7), value: animateIn)

            buttonsRow
                .padding(.bottom, 16)
        }
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
        .opacity(animateIn ? 1 : 0)
    }

    private var buttonsRow: some View {
        Button {
            handleContinue()
        } label: {
            HStack(spacing: 8) {
                Text(isLastPage ? "Continuar" : "Avançar")
                    .textCase(.uppercase)
                    .fontWeight(.semibold)
                    .font(isLandscape ? .subheadline : .body)

                if !isLastPage {
                    Image(systemName: "chevron.right")
                        .font(.subheadline.weight(.semibold))
                }
            }
            .frame(maxWidth: isLandscape ? 160 : .infinity)
            .padding(.vertical, isLandscape ? 12 : 16)
            .background(theme.button.primary.color ?? .blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .opacity(animateIn ? 1 : 0)
        .animation(reduceMotion ? nil : .easeOut(duration: 0.5).delay(0.8), value: animateIn)
        .accessibilityLabel(isLastPage ? "Continuar para permissões" : "Avançar para próxima página")
        .accessibilityHint(isLastPage ? "Vai para a tela de permissões" : "Mostra mais novidades")
    }

    // MARK: - Actions

    private func handleContinue() {
        if currentPage < pages.count - 1 {
            withAnimation(reduceMotion ? nil : .smooth) {
                currentPage += 1
            }
        } else {
            coordinator.navigate(to: .permissions)
        }
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
