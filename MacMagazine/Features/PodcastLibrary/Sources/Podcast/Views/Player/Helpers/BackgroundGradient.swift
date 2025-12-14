import Foundation
import SwiftUI
import UIKit

struct BackgroundGradientStatus {
    let colors: [Color]
    let isDark: Bool
}

final class BackgroundGradient {
    static func updateBackgroundGradient(
        data: Data?,
        backgroundGradientStyle: PodcastBackgroundGradientStyle
    ) async -> BackgroundGradientStatus {
        guard let data else {
            return BackgroundGradientStatus(colors: [.black, .black], isDark: false)
        }

        let selectedStyle = backgroundGradientStyle

        let result = await processArtworkColors(
            from: nil,
            data: data,
            style: selectedStyle
        )
        return BackgroundGradientStatus(colors: result.colors, isDark: result.isDark)
    }

    static func updateBackgroundGradient(
        artworkURL: String?,
        backgroundGradientStyle: PodcastBackgroundGradientStyle
    ) async -> BackgroundGradientStatus {
        guard let artworkURL,
              let url = URL(string: artworkURL) else {
            return BackgroundGradientStatus(colors: [.black, .black], isDark: false)
        }

        let selectedStyle = backgroundGradientStyle

        let result = await processArtworkColors(
            from: url,
            data: nil,
            style: selectedStyle
        )
        return BackgroundGradientStatus(colors: result.colors, isDark: result.isDark)
    }

    private static func processArtworkColors(
        from artworkURL: URL?,
        data: Data?,
        style: PodcastBackgroundGradientStyle
    ) async -> BackgroundGradientStatus {
        var artworkImage: UIImage?

        if let data {
            artworkImage = UIImage(data: data)
        } else if let artworkURL {
            let request = URLRequest(url: artworkURL, cachePolicy: .returnCacheDataElseLoad)
            if let (imageData, _) = try? await URLSession.shared.data(for: request),
               let image = UIImage(data: imageData) {
                artworkImage = image
            }
        }

        guard let artworkImage else {
            return BackgroundGradientStatus(colors: [.black, .black], isDark: false)
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

        return BackgroundGradientStatus(colors: swiftUIColors, isDark: isDark)
    }
}
