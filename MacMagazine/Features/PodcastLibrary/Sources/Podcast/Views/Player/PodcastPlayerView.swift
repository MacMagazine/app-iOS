import FeedLibrary
import MacMagazineLibrary
import MacMagazineUILibrary
import SwiftUI
import UIComponentsLibrary
import UtilityLibrary

// MARK: - Estilo de degradê de fundo

public enum PodcastBackgroundGradientStyle {
    case twoTone
    case threeTone
    case fourTone
}

// MARK: - PodcastPlayerView

public struct PodcastPlayerView: View {
    @Environment(\.theme) private var theme
    @Bindable private var playerManager: PodcastPlayerManager

    private let backgroundGradientStyle: PodcastBackgroundGradientStyle

    @State private var isShowingSpeedDialog = false
    @State private var isUsingAdvancedSpeedControl = false
    @State private var backgroundGradientColors: [Color] = [
        .black,
        .black
    ]

    @State private var isDarkBackground = false
    @State private var hasAppeared = false

    // MARK: - Init

    public init(
        playerManager: PodcastPlayerManager,
        backgroundGradientStyle: PodcastBackgroundGradientStyle = .fourTone
    ) {
        self.playerManager = playerManager
        self.backgroundGradientStyle = backgroundGradientStyle
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let isPad = UIDevice.current.userInterfaceIdiom == .pad
            let isPadPortrait = size.height >= size.width

            let horizontalPadding: CGFloat = {
                guard isPad else { return 20 }
                return isPadPortrait ? 80 : 300
            }()

            let artworkSize: CGFloat = isPad ? 640 : 320

            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: backgroundGradientColors),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    if let podcast = playerManager.currentPodcast {
                        fullPlayerContent(
                            podcast: podcast,
                            artworkSize: artworkSize,
                            horizontalPadding: horizontalPadding
                        )
                    }
                }
            }
            .frame(width: size.width, height: size.height)
            .preferredColorScheme(isDarkBackground ? .dark : .light)
            .onAppear {
                updateBackgroundGradient()
                hasAppeared = true
            }
            .onChange(of: playerManager.currentPodcast?.artworkURL) { _, _ in
                updateBackgroundGradient()
            }
        }
    }

    // MARK: - Layout principal

    @ViewBuilder
    private func fullPlayerContent(
        podcast: PodcastDB,
        artworkSize: CGFloat,
        horizontalPadding: CGFloat
    ) -> some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Spacer()

                artworkView(
                    artworkURL: URL(string: podcast.artworkURL),
                    maxSize: artworkSize
                )

                Spacer()

                podcastTitle(podcast.title)
                progressSlider
                playbackControls
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Controles de volume / AirPlay

private extension PodcastPlayerView {

    @ViewBuilder
    func artworkView(artworkURL: URL?, maxSize: CGFloat) -> some View {
        if let artworkURL {
            let haloColor: Color = isDarkBackground
            ? .white.opacity(0.55)
            : .black.opacity(0.55)

            let isPlaying = playerManager.isPlaying

            CachedAsyncImage(image: artworkURL)
                .cornerRadius(24)
                .frame(maxWidth: maxSize, maxHeight: maxSize)
                .scaleEffect(isPlaying ? 1.05 : 0.8)
                .shadow(
                    color: Color.black.opacity(isPlaying ? 0.3 : 0.0),
                    radius: 28,
                    x: 0,
                    y: 16
                )
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(haloColor)
                        .blur(radius: 36)
                        .opacity(isPlaying ? 1.0 : 0.0)
                        .scaleEffect(1.18)
                )
                .padding(.bottom, 20)
                .animation(
                    hasAppeared ? .easeInOut(duration: 0.35) : nil,
                    value: isPlaying
                )
        }
    }

    @ViewBuilder
    func artworkHaloBackground(
        maxSize: CGFloat,
        cornerRadius: CGFloat,
        accentColor: Color
    ) -> some View {
        if playerManager.isPlaying {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    RadialGradient(
                        colors: [
                            accentColor.opacity(0.35),
                            accentColor.opacity(0.0)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: maxSize
                    )
                )
                .scaleEffect(1.35)
                .blur(radius: 32)
                .animation(.easeInOut(duration: 0.6), value: playerManager.isPlaying)
        } else {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.clear)
        }
    }

    @ViewBuilder
    func podcastTitle(_ title: String) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Text(title)
                .font(.headline)
                .lineLimit(3)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, 8)
    }

    @ViewBuilder
    var playbackControls: some View {
        ZStack {
            HStack {
                speedButton
                Spacer()
            }

            HStack(spacing: 40) {
                skipButton(
                    systemName: "gobackward.15",
                    action: { playerManager.skip(by: -15) }
                )

                playPauseButton

                skipButton(
                    systemName: "goforward.15",
                    action: { playerManager.skip(by: 15) }
                )
            }
        }
        .tint(.primary)
        .padding(.top, 24)
    }

    // MARK: - Progress slider (com tempo restante correto)

    @ViewBuilder
    private var progressSlider: some View {
        let rawDuration = playerManager.duration
        let safeDuration: Double = {
            guard rawDuration.isFinite,
                  !rawDuration.isNaN,
                  rawDuration > 0 else {
                return 0.1
            }
            return rawDuration
        }()

        let elapsedTime: TimeInterval = {
            let currentTime = playerManager.currentTime
            guard currentTime.isFinite, !currentTime.isNaN else { return 0 }
            return min(max(0, currentTime), safeDuration)
        }()

        let remainingTime: TimeInterval = max(0, safeDuration - elapsedTime)

        VStack(spacing: 0) {
            Slider(
                value: Binding(
                    get: { elapsedTime },
                    set: { newValue in
                        playerManager.seek(to: newValue)
                    }
                ),
                in: 0...safeDuration
            )
            .sliderThumbVisibility(.hidden)
            .tint(.primary)

            HStack {
                Text(formatTime(elapsedTime))
                Spacer()
                Text("-" + formatTime(remainingTime))
            }
            .font(.caption)
            .foregroundColor(.primary.opacity(0.6))
        }
        .padding(.bottom)
    }

    @ViewBuilder
    var playPauseButton: some View {
        Button {
            playerManager.togglePlayPause()
        } label: {
            Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
        }
        .font(.system(size: 52))
    }

    @ViewBuilder
    func skipButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
        }
        .font(.system(size: 28))
    }
}

// MARK: - Speed button + popup

private extension PodcastPlayerView {

    @ViewBuilder
    var speedButton: some View {
        let currentSpeed = Double(playerManager.playbackRate)
        let isBoosted = abs(currentSpeed - 1.0) > 0.001

        let currentLabel = formattedSpeedForButton(currentSpeed)

        let widestLabel: String = {
            let candidateSpeeds: [Double] = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0, 2.5, 3.0]
            let labels = candidateSpeeds.map { formattedSpeedForButton($0) }
            return labels.max(by: { $0.count < $1.count }) ?? currentLabel
        }()

        Button {
            isUsingAdvancedSpeedControl = false
            isShowingSpeedDialog = true
        } label: {
            ZStack {
                Text(widestLabel)
                    .opacity(0)

                Text(currentLabel)
                    .opacity(0.6)
            }
            .font(.system(size: 15))
            .padding(.horizontal, 4)
            .shadow(
                color: isBoosted ? Color.primary.opacity(0.6) : .clear,
                radius: isBoosted ? 2 : 0,
                x: 0,
                y: 0
            )
        }
        .transaction { transaction in
            transaction.animation = nil
        }
        .popover(
            isPresented: $isShowingSpeedDialog,
            attachmentAnchor: .rect(.bounds)
        ) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Velocidade de reprodução")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 18)

                Divider()

                speedPopoverContent
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 4)
                    .padding(.bottom, 2)
                    .presentationCompactAdaptation(.popover)

                Text(
                    isUsingAdvancedSpeedControl
                    ? "Ajuste a velocidade de reprodução"
                    : "Deslize para ver mais velocidades"
                )
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)
                .padding(.bottom, 10)   // 🔽 bem menor que 18
            }
            .padding(.horizontal, 20)
            .dynamicTypeSize(.medium)
        }
    }

    var speedOptions: [Double] {
        [0.75, 1.0, 1.25, 1.5, 2.0]
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

                        Text(formattedSpeedForButton(speed))
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
        .padding(.vertical, 8)
    }

    @ViewBuilder
    var advancedSpeedControl: some View {
        SpeedWheelPicker(
            value: Binding(
                get: { Double(playerManager.playbackRate) },
                set: { newValue in
                    playerManager.setPlaybackRate(Float(newValue))
                    hapticTick()
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

// MARK: - Helpers (tempo, velocidade, haptic, degradê)

private extension PodcastPlayerView {

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

    func formattedSpeedForButton(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.minimumFractionDigits = value == 1.0 ? 0 : 1
        formatter.maximumFractionDigits = 1

        let base = formatter.string(from: NSNumber(value: value)) ?? String(value)
        return base + "x"
    }

    func hapticTick() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    func updateBackgroundGradient() {
        guard let artworkURLString = playerManager.currentPodcast?.artworkURL,
              let artworkURL = URL(string: artworkURLString) else {
            backgroundGradientColors = [.black, .black]
            isDarkBackground = false
            return
        }

        let selectedStyle = backgroundGradientStyle

        Task(priority: .background) {
            let result = await processArtworkColors(
                from: artworkURL,
                style: selectedStyle
            )

            await MainActor.run {
                backgroundGradientColors = result.colors
                isDarkBackground = result.isDark
            }
        }
    }

    func processArtworkColors(
        from artworkURL: URL,
        style: PodcastBackgroundGradientStyle
    ) async -> (colors: [Color], isDark: Bool) {
        let request = URLRequest(
            url: artworkURL,
            cachePolicy: .returnCacheDataElseLoad
        )

        guard
            let (imageData, _) = try? await URLSession.shared.data(for: request),
            let artworkImage = UIImage(data: imageData)
        else {
            return ([.black, .black], false)
        }

        var uiGradientColors: [UIColor] = [UIColor.black, UIColor.black]

        switch style {
        case .fourTone:
            if let fourToneColors = artworkImage.fourToneGradientColors() {
                uiGradientColors = fourToneColors
            } else if let threeToneColors = artworkImage.threeToneGradientColors() {
                uiGradientColors = threeToneColors
            } else if let twoToneTuple = artworkImage.twoToneGradientColors() {
                uiGradientColors = [twoToneTuple.0, twoToneTuple.1]
            }

        case .threeTone:
            if let threeToneColors = artworkImage.threeToneGradientColors() {
                uiGradientColors = threeToneColors
            } else if let twoToneTuple = artworkImage.twoToneGradientColors() {
                uiGradientColors = [twoToneTuple.0, twoToneTuple.1]
            }

        case .twoTone:
            if let twoToneTuple = artworkImage.twoToneGradientColors() {
                uiGradientColors = [twoToneTuple.0, twoToneTuple.1]
            }
        }

        let swiftUIColors = uiGradientColors.map { Color(uiColor: $0) }

        let brightnessValues = uiGradientColors.map { $0.perceivedBrightness }
        let totalBrightness = brightnessValues.reduce(0, +)
        let averageBrightness = brightnessValues.isEmpty
            ? CGFloat(0.5)
            : totalBrightness / CGFloat(brightnessValues.count)

        let isDark = averageBrightness < 0.6

        return (swiftUIColors, isDark)
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var playerManager = PodcastPlayerManager()

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

    PodcastPlayerView(
        playerManager: playerManager,
        backgroundGradientStyle: .fourTone
    )
    .environment(\.theme, ThemeColor())
    .onAppear {
        playerManager.currentPodcast = mockPodcast
        playerManager.duration = 2_730
        playerManager.currentTime = 450
    }
}
