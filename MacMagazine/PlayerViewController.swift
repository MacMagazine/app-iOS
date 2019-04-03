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

	var player: AVAudioPlayer = AVAudioPlayer()
	var timer: Timer?

    var podcast: Podcast? {
        didSet {
			if podcast == nil {
				timer?.invalidate()
				player.pause()
				playButton.isSelected = false
			} else {
				podcastTitle.text = podcast?.title
				podcastDuration.text = podcast?.duration

				spin.startAnimating()
				playButton.isHidden = spin.isAnimating
				loadPlayer()
			}
        }
    }

    // MARK: - View lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		do {
			try AVAudioSession.sharedInstance().setCategory(.playback)
		} catch {
			print(error.localizedDescription)
		}
    }

    // MARK: - Actions -

    @IBAction private func play(_ sender: Any) {
        if player.isPlaying {
			player.pause()
			playButton.isSelected = false
        } else {
			player.play()
			playButton.isSelected = true
			startTimer()
		}
    }

    @IBAction private func sliderValueChanged(_ slider: UISlider) {
		player.stop()
		player.currentTime = TimeInterval(slider.value)
		player.prepareToPlay()
		player.play()
    }

    // MARK: - Methods -

	func startTimer() {
		timer?.invalidate()
		timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
	}

	@objc func updateTime() {
		let remaining = player.duration - player.currentTime
		podcastDuration.text = self.secondsToHoursMinutesSeconds(Int(remaining))
		slider.value = Float(player.currentTime)
	}

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
		Network.get(url: url) { (data: Data?, _: String?) in
			guard let data = data else {
				return
			}

			DispatchQueue.main.async {
				self.spin.stopAnimating()
				self.playButton.isHidden = self.spin.isAnimating

				do {
					self.player = try AVAudioPlayer(data: data)

					self.player.prepareToPlay()
					self.player.play()
					self.startTimer()

					self.slider.maximumValue = Float(self.player.duration)
					self.podcastDuration.text = self.secondsToHoursMinutesSeconds(Int(self.player.duration))
					self.playButton.isSelected = true
				} catch {
					self.playButton.isEnabled = false
				}
			}
		}

	}

}
