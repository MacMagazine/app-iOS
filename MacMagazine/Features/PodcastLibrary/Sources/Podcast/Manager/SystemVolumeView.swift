import AVKit
import MediaPlayer
import SwiftUI

struct SystemVolumeView: UIViewRepresentable {
    func makeUIView(context: Context) -> MPVolumeView {
        let volumeView = MPVolumeView(frame: .zero)
        volumeView.setVolumeThumbImage(UIImage(), for: .normal) // Hide thumb if needed

        // Add a hidden AVRoutePickerView to avoid using deprecated showsRouteButton API
        let routePicker = AVRoutePickerView(frame: .zero)
        routePicker.isUserInteractionEnabled = false
        routePicker.alpha = 0.01 // effectively hidden
        routePicker.translatesAutoresizingMaskIntoConstraints = false
        volumeView.addSubview(routePicker)
        // Pin to zero size so it doesn't affect layout
        NSLayoutConstraint.activate([
            routePicker.widthAnchor.constraint(equalToConstant: 0.0),
            routePicker.heightAnchor.constraint(equalToConstant: 0.0)
        ])

        return volumeView
    }

    func updateUIView(_ uiView: MPVolumeView, context: Context) {}
}
