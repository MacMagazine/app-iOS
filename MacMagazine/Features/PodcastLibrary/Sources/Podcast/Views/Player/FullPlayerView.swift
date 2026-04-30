import AnalyticsLibrary
import FeedLibrary
import MacMagazineLibrary
import MacMagazineUILibrary
import SwiftUI
import UIComponentsLibrary

// MARK: - Gradient background styles -

enum Constants {
    static let coverURL = "https://macmagazine.com.br/wp-content/uploads/powerpress/capa.png"
}

// MARK: - Gradient background styles -

enum PodcastBackgroundGradientStyle {
    case twoTone
    case threeTone
    case fourTone
}

// MARK: - Accessibility Sort Priority -

enum PlayerAccessibilityPriority {
    static let favoriteButton: Double = 12
    static let shareButton: Double = 11
    static let podcastTitle: Double = 10
    static let previousChapter: Double = 9
    static let progressSlider: Double = 8
    static let nextChapter: Double = 7
    static let speedButton: Double = 6
    static let skipBackwardButton: Double = 5
    static let playPauseButton: Double = 4
    static let skipForwardButton: Double = 3
    static let chaptersButton: Double = 2
    static let volumeSlider: Double = 1
}

// MARK: - PodcastPlayerView -

struct FullPlayerView: View {
    @EnvironmentObject private var analytics: AnalyticsManager
    @Environment(\.modelContext) private var modelContext
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Bindable private var playerManager: PodcastPlayerManager

    private let backgroundGradientStyle: PodcastBackgroundGradientStyle

    @State private var isShowingSpeedDialog = false
    @State private var isShowingChapterDialog = false
    @State private var isUsingAdvancedSpeedControl = false
    @State private var backgroundGradientColors: [Color] = [.black, .black]
    @State private var isDarkBackground = false
    @State private var hasAppeared = false
    @State private var scrubbingTime: TimeInterval = 0

    private var speedOptions: [Double] {
        [0.75, 1.0, 1.25, 1.5, 2.0]
    }

    init(
        playerManager: PodcastPlayerManager,
        backgroundGradientStyle: PodcastBackgroundGradientStyle
    ) {
        self.playerManager = playerManager
        self.backgroundGradientStyle = backgroundGradientStyle
    }

    // MARK: - Body

    var body: some View {
        player
            .trackScreen(AnalyticsConstants.Screen.podcastFullPlayer.name, analytics: analytics)
            .sheet(isPresented: $isShowingChapterDialog) {
                ChaptersView(
                    playerManager: playerManager,
                    backgroundGradientStyle: backgroundGradientStyle,
                    isShowingChapterDialog: $isShowingChapterDialog
                )
                .presentationDragIndicator(.visible)
            }
    }

    var player: some View {
        ZStack {
            BackgroundView(
                chapter: playerManager.currentChapter,
                backgroundGradientColors: backgroundGradientColors,
                usesGradient: false
            )
            fullPlayerContent(podcast: playerManager.currentPodcast)
        }
        .preferredColorScheme(isDarkBackground ? .dark : .light)
        .onAppear {
            updateBackgroundGradient()
            hasAppeared = true
        }
        .onDisappear {
            playerManager.currentPodcast?.save(current: playerManager.currentTime, using: modelContext)
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.podcastCloseFullPlayer.id,
                screen: AnalyticsConstants.Screen.podcastFullPlayer.name
            ))
        }
        .onChange(of: playerManager.currentPodcast?.artworkURL) { _, value in
            updateBackgroundGradient(url: value)
        }
        .onChange(of: playerManager.currentChapter?.artworkData) { _, value in
            updateBackgroundGradient(data: value)
        }
    }

    // MARK: - Layout principal

    @ViewBuilder
    private func fullPlayerContent(podcast: PodcastDB?) -> some View {
        if let podcast {
            if verticalSizeClass == .compact {
                // Layout B - Horizontal (iPhone landscape fullscreen)
                HStack(spacing: 40) {
                    artworkView

                    VStack(spacing: 20) {
                        HStack(spacing: 0) {
                            Spacer()
                            actions
                        }

                        Spacer()

                        podcastTitle(podcast.title)

                        Spacer()

                        progressSlider
                        playbackControls
                        volumeSlider
                    }
                    .padding(.vertical, 40)
                }
                .padding(.horizontal)

            } else {
                // Layout A - Vertical (iPhone portrait medium + iPad centered)
                VStack(spacing: 16) {
                    HStack(spacing: 0) {
                        Spacer()
                        actions
                    }
                    .padding(.top, 5)

                    artworkView
                        .layoutPriority(-1)
                    podcastTitle(podcast.title)

                    Spacer(minLength: 8)

                    progressSlider
                        .padding(.bottom, 16)
                    playbackControls
                        .padding(.bottom, 16)
                    volumeSlider
                        .padding(.bottom, 16)
                }
                .padding(.horizontal)
            }
        }
    }
}

private extension FullPlayerView {
    @ViewBuilder
    var actions: some View {
        if let podcast = playerManager.currentPodcast?.toCardContent(
            using: modelContext,
            analytics: analytics,
            screen: "Podcast Full-player"
        ) {
            let favoriteButton = FavoriteButton(
                name: podcast.title,
                favorite: podcast.favorite,
                action: podcast.favoriteAction
            )
            .accessibilitySortPriority(PlayerAccessibilityPriority.favoriteButton)

            let shareButton = ShareButton(
                title: podcast.title,
                url: podcast.urlToShare
            )
            .accessibilitySortPriority(PlayerAccessibilityPriority.shareButton)

            FavoriteShareGlassContainer(
                favoriteView: favoriteButton,
                shareView: shareButton
            )
        }
    }
}

// MARK: - Controles de volume / AirPlay -

private extension FullPlayerView {
    @ViewBuilder
    var artworkView: some View {
        PodcastImageView(
            artworkData: playerManager.currentChapter?.artworkData,
            location: .player,
            fallback: { EmptyView() })
        .cornerRadius(24)
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: 540, maxHeight: 540)
        .scaleEffect(playerManager.isPlaying ? 0.95 : 0.85)
        .shadow(
            color: Color.black.opacity(0.3),
            radius: 28,
            x: 0,
            y: 16
        )
        .padding(.horizontal)
        .accessibilityHidden(true)
        .id(playerManager.currentChapter?.id ?? UUID())
        .transition(.opacity)
        .animation(
            .easeInOut(duration: 0.35),
            value: playerManager.isPlaying
        )
    }

    @ViewBuilder
    func podcastTitle(_ title: String) -> some View {
        Ticker(text: title, speed: 30)
            .bold()
            .frame(height: 40)
            .accessibilityLabel(title)
            .accessibilityAddTraits(.isHeader)
            .accessibilitySortPriority(PlayerAccessibilityPriority.podcastTitle)
    }

    @ViewBuilder
    var playbackControls: some View {
        ZStack {
            HStack {
                speedButton
                    .accessibilitySortPriority(PlayerAccessibilityPriority.speedButton)
                Spacer()
                chaptersButton
                    .accessibilitySortPriority(PlayerAccessibilityPriority.chaptersButton)
            }

            HStack(spacing: 40) {
                skipButton(
                    systemName: "gobackward.15",
                    label: "Voltar 15 segundos",
                    action: {
                        playerManager.skip(by: -15)
                        analytics.track(.buttonTap(
                            buttonId: AnalyticsConstants.ButtonID.podcastSkipMinus15.id,
                            screen: AnalyticsConstants.Screen.podcastFullPlayer.name
                        ))
                    }
                )
                .accessibilitySortPriority(PlayerAccessibilityPriority.skipBackwardButton)

                playPauseButton
                    .accessibilitySortPriority(PlayerAccessibilityPriority.playPauseButton)

                skipButton(
                    systemName: "goforward.15",
                    label: "Avançar 15 segundos",
                    action: {
                        playerManager.skip(by: 15)
                        analytics.track(.buttonTap(
                            buttonId: AnalyticsConstants.ButtonID.podcastSkipPlus15.id,
                            screen: AnalyticsConstants.Screen.podcastFullPlayer.name
                        ))
                    }
                )
                .accessibilitySortPriority(PlayerAccessibilityPriority.skipForwardButton)
            }
        }
        .tint(.primary)
    }

    // MARK: - Progress slider (com tempo restante correto)

    @ViewBuilder
    var progressSlider: some View {
        let rawDuration = playerManager.duration
        let safeDuration: Double = {
            guard rawDuration.isFinite,
                  !rawDuration.isNaN,
                  rawDuration > 0 else {
                return 0.1
            }
            return rawDuration
        }()

        let displayTime: TimeInterval = {
            let time = playerManager.isScrubbing ? scrubbingTime : playerManager.currentTime
            guard time.isFinite, !time.isNaN else { return 0 }
            return min(max(0, time), safeDuration)
        }()

        let remainingTime: TimeInterval = max(0, safeDuration - displayTime)

        VStack(spacing: 0) {
            HStack(spacing: 20) {
                Button(action: {
                    playerManager.toPreviousChapter()
                    analytics.track(.buttonTap(
                        buttonId: AnalyticsConstants.ButtonID.podcastPreviousChapter.id,
                        screen: AnalyticsConstants.Screen.podcastFullPlayer.name
                    ))
                },
                       label: {
                    Image(systemName: "backward.end")
                })
                .font(.system(size: 20))
                .accessibilityLabel("Capítulo anterior")
                .accessibilitySortPriority(PlayerAccessibilityPriority.previousChapter)

                Slider(
                    value: Binding(
                        get: { displayTime },
                        set: { newValue in
                            scrubbingTime = newValue
                            if !playerManager.isScrubbing {
                                playerManager.isScrubbing = true
                            }
                        }
                    ),
                    in: 0...safeDuration,
                    onEditingChanged: { editing in
                        if !editing {
                            playerManager.seek(to: scrubbingTime)
                            playerManager.isScrubbing = false
                        }
                    }
                )
                .sliderThumbVisibility(.hidden)
                .tint(.primary)
                .accessibilityLabel("Posição da reprodução")
                .accessibilityValue("\(formatTime(displayTime)) de \(formatTime(safeDuration))")
                .accessibilitySortPriority(PlayerAccessibilityPriority.progressSlider)

                Button(action: {
                    playerManager.toNextChapter()
                    analytics.track(.buttonTap(
                        buttonId: AnalyticsConstants.ButtonID.podcastNextChapter.id,
                        screen: AnalyticsConstants.Screen.podcastFullPlayer.name
                    ))
                },
                       label: {
                    Image(systemName: "forward.end")
                })
                .font(.system(size: 20))
                .accessibilityLabel("Próximo capítulo")
                .accessibilitySortPriority(PlayerAccessibilityPriority.nextChapter)
            }

            HStack {
                Text(formatTime(displayTime))
                Spacer()
                Text("-" + formatTime(remainingTime))
            }
            .font(.caption)
            .foregroundColor(.primary.opacity(0.6))
            .padding(.horizontal, 40)
            .accessibilityHidden(true)
        }
    }

    // MARK: - Volume slider

    var volumeSlider: some View {
        HStack(spacing: 20) {
            Image(systemName: "speaker.wave.1")
                .foregroundColor(.secondary)
                .font(.system(size: 20))
                .accessibilityHidden(true)

            SystemVolumeView()
                .tint(.primary)
                .frame(height: 18)
                .accessibilityLabel("Volume")
                .accessibilitySortPriority(PlayerAccessibilityPriority.volumeSlider)

            Image(systemName: "speaker.wave.3")
                .foregroundColor(.secondary)
                .font(.system(size: 20))
                .accessibilityHidden(true)
        }
    }

    @ViewBuilder
    var playPauseButton: some View {
        Button {
            playerManager.togglePlayPause()
            playerManager.currentPodcast?.save(current: playerManager.currentTime, using: modelContext)
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.podcastTogglePlayPause.id,
                screen: AnalyticsConstants.Screen.podcastFullPlayer.name
            ))
        } label: {
            Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
        }
        .font(.system(size: 52))
        .accessibilityLabel(playerManager.isPlaying ? "Pausar" : "Reproduzir")
    }

    @ViewBuilder
    func skipButton(systemName: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
        }
        .font(.system(size: 28))
        .accessibilityLabel(label)
    }
}

// MARK: - Chapter button -

private extension FullPlayerView {
    @ViewBuilder
    var chaptersButton: some View {
        if playerManager.chapters.isEmpty {
            EmptyView()
        } else {
            Button(action: {
                isShowingChapterDialog.toggle()
                analytics.track(.buttonTap(
                    buttonId: AnalyticsConstants.ButtonID.podcastShowChapters.id,
                    screen: AnalyticsConstants.Screen.podcastFullPlayer.name
                ))
            }, label: {
                Image(systemName: "music.note.list")
                    .opacity(0.6)
                    .font(.system(size: 15))
            })
            .font(.system(size: 24))
            .accessibilityLabel("Lista de capítulos")
        }
    }
}

// MARK: - Speed button + popup -

private extension FullPlayerView {
    @ViewBuilder
    var speedButton: some View {
        let currentSpeed = Double(playerManager.playbackRate)
        let isBoosted = abs(currentSpeed - 1.0) > 0.001

        let currentLabel = formattedSpeedForButton(currentSpeed, isSelected: true)

        Button {
            isUsingAdvancedSpeedControl = false
            isShowingSpeedDialog = true
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.podcastSpeedButton.id,
                screen: AnalyticsConstants.Screen.podcastFullPlayer.name
            ))
        } label: {
            Text(currentLabel)
                .opacity(0.6)
                .font(.system(size: 15))
                .padding(.horizontal, 4)
                .shadow(
                    color: isBoosted ? Color.primary.opacity(0.6) : .clear,
                    radius: isBoosted ? 2 : 0,
                    x: 0,
                    y: 0
                )
        }
        .accessibilityLabel("Velocidade de reprodução")
        .accessibilityValue(accessibleSpeedValue(currentSpeed))
        .accessibilityAddTraits(.allowsDirectInteraction)
        .accessibilityAdjustableAction { direction in
            let currentSpeed = Double(playerManager.playbackRate)
            switch direction {
            case .increment:
                playerManager.setPlaybackRate(Float(min(currentSpeed + 0.25, 3.0)))
            case .decrement:
                playerManager.setPlaybackRate(Float(max(currentSpeed - 0.25, 0.5)))
            @unknown default:
                break
            }
        }
        .popover(
            isPresented: $isShowingSpeedDialog,
            attachmentAnchor: .rect(.bounds)
        ) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Velocidade de reprodução")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    .padding(.bottom, 8)

                speedPopoverContent
                    .frame(maxWidth: .infinity, alignment: .center)
                    .presentationCompactAdaptation(.popover)

                Text(
                    isUsingAdvancedSpeedControl
                    ? "Ajuste a velocidade de reprodução"
                    : "Deslize para mais velocidades"
                )
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)
                .padding(.bottom)
                .accessibilityHidden(true)
            }
            .padding(.horizontal, 20)
            .dynamicTypeSize(.medium)
        }
    }

    @ViewBuilder
    var speedPopoverContent: some View {
        if isUsingAdvancedSpeedControl {
            advancedSpeedControl
        } else {
            simpleSpeedChips
                .highPriorityGesture(
                    DragGesture(minimumDistance: 8)
                        .onChanged { _ in
                            isUsingAdvancedSpeedControl = true
                        }
                )
        }
    }

    @ViewBuilder
    var simpleSpeedChips: some View {
        HStack(spacing: 10) {
            ForEach(speedOptions, id: \.self) { speed in
                Button {
                    playerManager.setPlaybackRate(Float(speed))
                    hapticTick()
                    isShowingSpeedDialog.toggle()
                    analytics.track(.buttonTap(
                        buttonId: AnalyticsConstants.ButtonID.podcastSpeed(speed).id,
                        screen: AnalyticsConstants.Screen.podcastFullPlayer.name
                    ))

                } label: {
                    let isSelected = abs(speed - Double(playerManager.playbackRate)) < 0.001

                    ZStack {
                        Circle()
                            .fill(
                                isSelected
                                ? Color.accentColor
                                : Color.primary.opacity(0.05)
                            )
                            .frame(width: 36, height: 36)

                        Text(formattedSpeedForButton(speed, isSelected: isSelected))
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(
                                isSelected
                                ? .white
                                : Color.primary.opacity(0.9)
                            )
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .frame(width: 200)
    }

    @ViewBuilder
    var advancedSpeedControl: some View {
        SpeedWheelPicker(
            value: Binding(
                get: { Double(playerManager.playbackRate) },
                set: { newValue in
                    playerManager.setPlaybackRate(Float(newValue))
                    hapticTick()
                    analytics.track(.buttonTap(
                        buttonId: AnalyticsConstants.ButtonID.podcastSpeedAdvanced(newValue).id,
                        screen: AnalyticsConstants.Screen.podcastFullPlayer.name
                    ))
                }
            ),
            minValue: 0.5,
            maxValue: 3.0,
            step: 0.1,
            width: 220,
            leftIcon: {
                Image(systemName: "tortoise.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            },
            rightIcon: {
                Image(systemName: "hare.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
        )
        .padding(.vertical, 4)
    }
}

// MARK: - Helpers (tempo, velocidade, haptic, degradê) -

private extension FullPlayerView {
    func formatTime(_ time: TimeInterval) -> String {
        guard time.isFinite, !time.isNaN else { return "0:00" }

        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }

    func accessibleSpeedValue(_ speed: Double) -> String {
        if abs(speed - 1.0) < 0.001 {
            return "normal"
        }
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "pt-BR")
        formatter.minimumFractionDigits = speed.truncatingRemainder(dividingBy: 1) == 0.0 ? 0 : 1
        formatter.maximumFractionDigits = 2
        let base = formatter.string(from: NSNumber(value: speed)) ?? String(speed)
        return "\(base) vezes"
    }

    func formattedSpeedForButton(_ value: Double, isSelected: Bool) -> String {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.minimumFractionDigits = value.truncatingRemainder(dividingBy: 1) == 0.0 ? 0 : 1
        formatter.maximumFractionDigits = 1

        let base = formatter.string(from: NSNumber(value: value)) ?? String(value)
        return base + (isSelected ? "x" : "")
    }

    func hapticTick() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    func updateBackgroundGradient(
        url: String? = nil,
        data: Data? = nil
    ) {
        BackgroundViewModel.backgroundGradient(
            data: data,
            artworkURL: url ?? playerManager.currentPodcast?.artworkURL,
            backgroundGradientStyle: backgroundGradientStyle,
            backgroundGradientColors: $backgroundGradientColors,
            isDarkBackground: $isDarkBackground
        )
    }
}

// MARK: - Preview -

#Preview {
    @Previewable @State var playerManager = PodcastPlayerManager()

    let analytics = AnalyticsManager()

    let mockPodcast = PodcastDB(
        postId: "1",
        title: "MacMagazine no Ar #123: Especial WWDC 2024",
        subtitle: "Neste episódio especial, discutimos todas as novidades anunciadas na WWDC 2024",
        pubDate: Date(),
        artworkURL: "https://macmagazine.com.br/wp-content/uploads/2025/11/28-podcast-1260x709.jpg",
        podcastURL: "https://traffic.libsyn.com/secure/macmagazine/MacMagazine_no_Ar_001.mp3",
        podcastSize: 50_000_000,
        duration: "45:30",
        podcastFrame: "",
        favorite: false,
        playable: true
    )

    FullPlayerView(
        playerManager: playerManager,
        backgroundGradientStyle: .fourTone
    )
    .onAppear {
        playerManager.currentPodcast = mockPodcast
        playerManager.duration = 2_730
        playerManager.currentTime = 450
    }
    .environmentObject(analytics)

}
