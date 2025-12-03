import AVFoundation
import Combine
import FeedLibrary
import Foundation
import MediaPlayer
import UIKit

@MainActor
@Observable
class PodcastPlayerManager {
    var currentPodcast: PodcastDB?
    var isPlaying: Bool = false
    var currentTime: TimeInterval = 0
    var duration: TimeInterval = 0
    var playbackRate: Float = 1.0

    private var player: AVPlayer?
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()
    private var isAudioSessionSetup = false
    private var isRemoteControlsSetup = false

    init() {
    }

    private func setupAudioSession() {
        guard !isAudioSessionSetup else { return }
        isAudioSessionSetup = true

        Task.detached {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Failed to setup audio session: \(error)")
            }
        }
    }

    private func setupRemoteTransportControls() {
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

    func loadPodcast(_ podcast: PodcastDB) {
        guard let url = URL(string: podcast.podcastURL) else { return }

        setupAudioSession()
        setupRemoteTransportControls()
        currentPodcast = podcast

        let playerItem = AVPlayerItem(url: url)

        if player == nil {
            player = AVPlayer(playerItem: playerItem)
        } else {
            player?.replaceCurrentItem(with: playerItem)
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

    private func setupTimeObserver() {
        guard let player = player else { return }

        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }

        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTime = time.seconds
        }
    }

    private func setupItemObservers(_ item: AVPlayerItem) {
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

    private func handlePlaybackEnd() {
        isPlaying = false
        currentTime = 0
        player?.seek(to: .zero)
        updateNowPlayingInfo()
    }

    private func updateNowPlayingInfo() {
        guard let podcast = currentPodcast else { return }

        let title = podcast.title
        let currentTimeValue = currentTime
        let durationValue = duration.isFinite && !duration.isNaN ? duration : 0
        let rateValue = isPlaying ? playbackRate : 0.0
        let artworkURLString = podcast.artworkURL

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

            if let artworkURL = URL(string: artworkURLString), !artworkURLString.isEmpty {
                do {
                    let (data, _) = try await URLSession.shared.data(from: artworkURL)
                    if let image = UIImage(data: data) {
                        let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
                        await MainActor.run {
                            var updatedInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
                            updatedInfo[MPMediaItemPropertyArtwork] = artwork
                            MPNowPlayingInfoCenter.default().nowPlayingInfo = updatedInfo
                        }
                    }
                } catch {
                    // Silently fail if artwork can't be loaded
                }
            }
        }
    }
}
