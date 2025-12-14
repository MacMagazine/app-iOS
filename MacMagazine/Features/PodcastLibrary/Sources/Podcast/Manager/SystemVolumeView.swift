import MediaPlayer
import SwiftUI

// MARK: - SwiftUI Wrapper for MPVolumeView -

struct SystemVolumeView: UIViewRepresentable {
    func makeUIView(context: Context) -> MPVolumeView {
        let volumeView = MPVolumeView(frame: .zero)
        // volumeView.showsRouteButton = false // Hide AirPlay button
        // volumeView.setVolumeThumbImage(UIImage(), for: .normal) // Hide thumb if needed
        return volumeView
    }

    func updateUIView(_ uiView: MPVolumeView, context: Context) {}
}

// MARK: - Volume Controller for SwiftUI -

@MainActor @Observable
class SystemVolumeController {
    private var volumeView: MPVolumeView

    init() {
        volumeView = MPVolumeView(frame: .zero)
    }

    private var volumeSlider: UISlider? {
        volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
    }

    var currentVolume: Float {
        volumeSlider?.value ?? 0.5
    }

    func setVolume(_ volume: Float) {
        volumeSlider?.value = min(max(volume, 0.0), 1.0)
    }

    func increaseVolume(by amount: Float = 0.1) {
        guard let slider = volumeSlider else { return }
        slider.value = min(slider.value + amount, 1.0)
    }

    func decreaseVolume(by amount: Float = 0.1) {
        guard let slider = volumeSlider else { return }
        slider.value = max(slider.value - amount, 0.0)
    }
}
