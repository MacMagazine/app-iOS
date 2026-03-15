import AVFoundation
import Combine
import FeedLibrary
import Foundation
import MacMagazineLibrary
import MediaPlayer
import Observation
import UIKit

@MainActor
@Observable
public class PodcastPlayerManager {
    var currentPodcast: PodcastDB?
    var isPlaying = false
    var isFullscreen = false
    var currentTime: TimeInterval = 0
    var duration: TimeInterval = 0
    var playbackRate: Float = 1.0
    var isScrubbing = false
    var chapters = [PodcastChapter]()

    /// Returns the currently playing chapter based on currentTime
    var currentChapter: PodcastChapter? {
        chapters.first { chapter in
            currentTime >= chapter.start.seconds &&
            currentTime < chapter.end.seconds
        }
    }

    private var player: AVPlayer?
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()
    private var isAudioSessionSetup = false
    private var isRemoteControlsSetup = false

    public init() {}

    public func observeSessionState(_ sessionState: SessionState) {
        Task { @MainActor [weak self] in
            while !Task.isCancelled {
                let isPlaying = withObservationTracking {
                    sessionState.isPlayingVideos
                } onChange: {}

                if isPlaying {
                    self?.pause()
                }

                try? await Task.sleep(for: .milliseconds(100))
            }
        }
    }
}

// MARK: - Public methods -

public extension PodcastPlayerManager {
    func loadPodcast(_ podcast: PodcastDB) {
        guard let url = URL(string: podcast.podcastURL) else { return }

        setupAudioSession()
        setupRemoteTransportControls()

        if currentPodcast == podcast {
            togglePlayPause()
            return
        }

        currentPodcast = podcast
        let playerItem = AVPlayerItem(url: url)

        if player == nil {
            player = AVPlayer(playerItem: playerItem)
        } else {
            player?.replaceCurrentItem(with: playerItem)
        }

        Task {
            chapters = await getChapter(using: url)
        }

        setupTimeObserver()
        setupItemObservers(playerItem)

        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.handlePlaybackEnd()
            }
        }

        play()
    }

    func play() {
        player?.play()
        player?.rate = playbackRate
        isPlaying = true
        updateNowPlayingInfo()
    }

    func pause() {
        player?.pause()
        isPlaying = false
        updateNowPlayingInfo()
    }

    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    func seek(to time: TimeInterval) {
        let cmTime = CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.seek(to: cmTime)
        updateNowPlayingInfo()
    }

    func skip(by seconds: Double) {
        let newTime = currentTime + seconds
        seek(to: max(0, min(newTime, duration)))
    }

    func setPlaybackRate(_ rate: Float) {
        playbackRate = rate
        if isPlaying {
            player?.rate = rate
        }
    }

    func toPreviousChapter() {
        if let currentChapter,
           let index = chapters.firstIndex(of: currentChapter),
           index > 0 {
            seek(to: chapters[index - 1].start.seconds)
        }
    }

    func toNextChapter() {
        if let currentChapter,
           let index = chapters.firstIndex(of: currentChapter),
           index < chapters.count {
            seek(to: chapters[index + 1].start.seconds)
        }
    }
}

// MARK: - Private methods -

private extension PodcastPlayerManager {
    func setupAudioSession() {
        guard !isAudioSessionSetup else { return }
        isAudioSessionSetup = true

        Task.detached {
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
            try? AVAudioSession.sharedInstance().setActive(true)
        }
    }

    func setupRemoteTransportControls() {
        guard !isRemoteControlsSetup else { return }
        isRemoteControlsSetup = true

        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [weak self] _ in
            Task { @MainActor in
                self?.play()
            }
            return .success
        }

        commandCenter.pauseCommand.addTarget { [weak self] _ in
            Task { @MainActor in
                self?.pause()
            }
            return .success
        }

        commandCenter.skipForwardCommand.preferredIntervals = [15]
        commandCenter.skipForwardCommand.addTarget { [weak self] _ in
            Task { @MainActor in
                self?.skip(by: 15)
            }
            return .success
        }

        commandCenter.skipBackwardCommand.preferredIntervals = [15]
        commandCenter.skipBackwardCommand.addTarget { [weak self] _ in
            Task { @MainActor in
                self?.skip(by: -15)
            }
            return .success
        }

        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let event = event as? MPChangePlaybackPositionCommandEvent else {
                return .commandFailed
            }
            Task { @MainActor in
                self?.seek(to: event.positionTime)
            }
            return .success
        }
    }

    func setupTimeObserver() {
        guard let player = player else { return }

        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }

        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            Task { @MainActor in
                guard !self.isScrubbing else { return }
                self.currentTime = time.seconds
            }
        }
    }

    func setupItemObservers(_ item: AVPlayerItem) {
        item.publisher(for: \.duration)
            .sink { [weak self] duration in
                self?.duration = duration.seconds
            }
            .store(in: &cancellables)

        item.publisher(for: \.status)
            .sink { [weak self] status in
                if status == .readyToPlay {
                    Task { @MainActor in
                        self?.updateNowPlayingInfo()
                    }
                }
            }
            .store(in: &cancellables)
    }

    func handlePlaybackEnd() {
        isPlaying = false
        currentTime = 0
        player?.seek(to: .zero)
        updateNowPlayingInfo()
    }

    func updateNowPlayingInfo() {
        guard let podcast = currentPodcast else { return }

        let title = podcast.title
        let currentTimeValue = currentTime
        let durationValue = duration.isFinite && !duration.isNaN ? duration : 0
        let rateValue = isPlaying ? playbackRate : 0.0

        Task.detached {
            var nowPlayingInfo = [String: Any]()
            nowPlayingInfo[MPMediaItemPropertyTitle] = title
            nowPlayingInfo[MPMediaItemPropertyArtist] = "MacMagazine"
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTimeValue
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = durationValue
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = rateValue

            await MainActor.run {
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            }
        }
    }
}

// MARK: - Chapter methods -

extension PodcastPlayerManager {
    func getChapter(using url: URL) async -> [PodcastChapter] {
        var response = [PodcastChapter]()
        let asset = AVURLAsset(url: url)
        let locales = (try? await asset.load(.availableChapterLocales)) ?? []

        for locale in locales {
            let chapters = (try? await asset.loadChapterMetadataGroups(
                withTitleLocale: locale,
                containingItemsWithCommonKeys: [AVMetadataKey.commonKeyArtwork]
            )) ?? []

            for chapter in chapters {
                let timeRange = chapter.timeRange

                let titleItem = AVMetadataItem.metadataItems(
                    from: chapter.items,
                    withKey: AVMetadataKey.commonKeyTitle,
                    keySpace: .common
                ).first
                let title: String = (try? await titleItem?.load(.stringValue)) ?? ""

                let artworkItem = AVMetadataItem.metadataItems(
                    from: chapter.items,
                    withKey: AVMetadataKey.commonKeyArtwork,
                    keySpace: .common
                ).first
                let artworkData = try? await artworkItem?.load(.dataValue)

                response.append(
                    PodcastChapter(
                        title: title,
                        start: timeRange.start,
                        end: timeRange.end,
                        duration: timeRange.duration,
                        artworkData: artworkData
                    )
                )
            }
        }
        return response.sorted
    }
}

// MARK: - Array Extension -

extension Array where Element == PodcastChapter {
    var sorted: Self {
        self.sorted(by: { $0.start.seconds < $1.start.seconds })
    }
}
