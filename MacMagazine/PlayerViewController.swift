//
//  PlayerViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 03/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import AVFoundation
import UIKit

struct Podcast {
    var title: String?
    var duration: String?
    var url: String?
}

class PlayerViewController: UIViewController {

    // MARK: - Properties -

    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var spin: UIActivityIndicatorView!
    @IBOutlet private weak var podcastTitle: UILabel!
    @IBOutlet private weak var podcastDuration: UILabel!
    @IBOutlet private weak var slider: UISlider!

    var player: AVPlayer = AVPlayer()

    var podcast: Podcast? {
        didSet {
            podcastTitle.text = podcast?.title
            podcastDuration.text = podcast?.duration

            spin.startAnimating()
            playButton.isHidden = spin.isAnimating
            loadPlayer()
        }
    }

    // MARK: - View lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - Actions -

    @IBAction private func play(_ sender: Any) {
        if player.rate == 0 {
            player.play()
            playButton.isSelected = true
        } else {
            player.pause()
            playButton.isSelected = false
        }
    }

    @IBAction private func sliderValueChanged(_ slider: UISlider) {
        let targetTime: CMTime = CMTimeMake(value: Int64(slider.value), timescale: 1)

        player.seek(to: targetTime)

        if player.rate == 0 {
            player.play()
        }
    }

    // MARK: - Methods -

    func secondsToHoursMinutesSeconds(_ seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional

        guard let formattedString = formatter.string(from: TimeInterval(seconds)) else {
            return ""
        }
        return formattedString
    }

    fileprivate func loadPlayer() {
        guard let url = URL(string: podcast?.url ?? "") else {
            return
        }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) {
            _ in

            if self.player.currentItem?.status == .readyToPlay {
                let time = CMTimeGetSeconds(self.player.currentTime())
                self.slider.value = Float(time)

                let remaining = self.slider.maximumValue - self.slider.value
                self.podcastDuration.text = self.secondsToHoursMinutesSeconds(Int(remaining))
            }
        }

        DispatchQueue.global().async { [weak self] in
            let seconds = CMTimeGetSeconds(playerItem.asset.duration)

            DispatchQueue.main.async { [weak self] in
                self?.slider.maximumValue = Float(seconds)
                self?.podcastDuration.text = self?.secondsToHoursMinutesSeconds(Int(seconds))

                self?.player.play()

                self?.spin.stopAnimating()
                self?.playButton.isHidden = self?.spin.isAnimating ?? true
                self?.playButton.isSelected = true
            }
        }
    }

}
