import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

struct ChaptersView: View {
    @EnvironmentObject private var analytics: AnalyticsManager
    @Bindable private var playerManager: PodcastPlayerManager
    @Binding private var isShowingChapterDialog: Bool

    @State private var backgroundGradientColors: [Color] = [.black, .black]
    @State private var isDarkBackground = false

    private let backgroundGradientStyle: PodcastBackgroundGradientStyle

    init(
        playerManager: PodcastPlayerManager,
        backgroundGradientStyle: PodcastBackgroundGradientStyle,
        isShowingChapterDialog: Binding<Bool>
    ) {
        self.playerManager = playerManager
        self.backgroundGradientStyle = backgroundGradientStyle
        _isShowingChapterDialog = isShowingChapterDialog
    }

    var body: some View {
        ZStack {
            BackgroundView(
                chapter: playerManager.currentChapter,
                backgroundGradientColors: backgroundGradientColors,
                usesGradient: false
            )
            .ignoresSafeArea()

            content
        }
        .trackScreen(
            AnalyticsConstants.Screen.podcastChapters.name,
            previous: nil,
            analytics: analytics
        )
        .safeAreaInset(edge: .top) {
            Capsule()
                .fill(.white.opacity(isDarkBackground ? 0.35 : 0.45))
                .frame(width: 44, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 6)
                .accessibilityHidden(true)
        }
        .preferredColorScheme(isDarkBackground ? .dark : .light)
        .onAppear {
            updateBackgroundGradient(data: playerManager.currentChapter?.artworkData)
        }
        .onChange(of: playerManager.currentChapter?.artworkData) { _, value in
            updateBackgroundGradient(data: value)
        }
    }
}

// MARK: - UI

private extension ChaptersView {
    var content: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(playerManager.chapters, id: \.id) { chapter in
                    chapterRow(chapter)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
    }

    func chapterRow(_ chapter: PodcastChapter) -> some View {
        let active = isActive(chapter)

        return Button {
            playerManager.seek(to: chapter.start.seconds)
            isShowingChapterDialog.toggle()
        } label: {
            HStack(spacing: 12) {
                PodcastImageView(
                    artworkData: chapter.artworkData,
                    location: .chapter,
                    fallback: { Rectangle().fill(.clear) }
                )
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                VStack(alignment: .leading, spacing: 8) {
                    Text(chapter.title)
                        .font(active ? .body.weight(.bold) : .body.weight(.semibold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)

                    HStack(spacing: 12) {
                        HStack(spacing: 6) {
                            Image(systemName: "clock")
                                .font(.system(size: 14))
                            Text(chapter.startString)
                        }

                        Spacer()

                        HStack(spacing: 6) {
                            Text(chapter.durationString)
                            Image(systemName: "microphone")
                                .font(.system(size: 14))
                        }
                    }
                    .font(.callout)
                    .foregroundStyle(.secondary)

                    if active {
                        TimelineView(.animation) { _ in
                            progressBar(for: chapter)
                        }
                        .transition(.opacity)
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(chapter.title), começando em \(chapter.startString) com duração de \(chapter.durationString).")
        .background {
            cardBackground(for: chapter)
        }
        .scaleEffect(active ? 1.015 : 1.0)
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: active)
    }
}

// MARK: - Card background (glass + highlight + “band” que acompanha o tempo)

private extension ChaptersView {
    func cardBackground(for chapter: PodcastChapter) -> some View {
        let active = isActive(chapter)

        return RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay {
                // Tint base (fica mais forte quando ativo)
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(chapterTintColor(for: chapter))
                    .opacity(active ? 0.38 : 0.18)
            }
            .overlay {
                // Highlight que “acompanha o tempo”: uma faixa luminosa posicionada pelo progress
                GeometryReader { proxy in
                    TimelineView(.animation) { _ in
                        let progress = progress(for: chapter)
                        let width = proxy.size.width
                        let bandWidth = min(140, width * 0.38)
                        let xOffset = max(0, min(1, progress)) * max(0, width - bandWidth)

                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .clear,
                                        .white.opacity(isDarkBackground ? 0.32 : 0.25),
                                        .clear
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: bandWidth)
                            .offset(x: xOffset)
                            .blur(radius: 10)
                            .opacity(active ? 1.0 : 0.0)
                            .animation(.linear(duration: 0.12), value: xOffset)
                    }
                }
                .mask(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                )
                .allowsHitTesting(false)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(
                        .white.opacity(
                            active ? 0.35 : (isDarkBackground ? 0.10 : 0.18)
                        ),
                        lineWidth: active ? 1.2 : 0.5
                    )
            }
    }

    func chapterTintColor(for chapter: PodcastChapter) -> Color {
        chapter.backgroundColor(at: playerManager.currentTime, using: backgroundGradientColors)
    }
}

// MARK: - Progress bar

private extension ChaptersView {
    func progressBar(for chapter: PodcastChapter) -> some View {
        let progress = progress(for: chapter)

        return GeometryReader { proxy in
            let proxyW = proxy.size.width
            let fillW = max(0, min(1, progress)) * proxyW

            ZStack(alignment: .leading) {
                Capsule(style: .continuous)
                    .fill(.white.opacity(isDarkBackground ? 0.12 : 0.16))

                Capsule(style: .continuous)
                    .fill(.white.opacity(isDarkBackground ? 0.75 : 0.65))
                    .frame(width: max(2, fillW))
                    .animation(.linear(duration: 0.12), value: fillW)
            }
        }
        .frame(height: 3)
        .padding(.top, 2)
        .accessibilityHidden(true)
    }
}

// MARK: - Active/progress helpers

private extension ChaptersView {
    func isActive(_ chapter: PodcastChapter) -> Bool {
        let time = playerManager.currentTime
        let start = chapter.start.seconds
        let end = chapter.end.seconds
        return time >= start && time < end
    }

    func progress(for chapter: PodcastChapter) -> CGFloat {
        let time = playerManager.currentTime
        let start = chapter.start.seconds
        let end = chapter.end.seconds
        let denom = max(0.001, end - start)
        return CGFloat((time - start) / denom)
    }
}

// MARK: - Background

private extension ChaptersView {
    func updateBackgroundGradient(data: Data? = nil) {
        BackgroundViewModel.backgroundGradient(
            data: data,
            artworkURL: Constants.coverURL,
            backgroundGradientStyle: backgroundGradientStyle,
            backgroundGradientColors: $backgroundGradientColors,
            isDarkBackground: $isDarkBackground
        )
    }
}
