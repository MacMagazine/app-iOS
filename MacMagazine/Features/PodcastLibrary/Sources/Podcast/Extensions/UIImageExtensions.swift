import UIKit

extension UIImage {

    private func averageColor() -> UIColor? {
        guard let cgImage = cgImage else { return nil }

        let targetSize = CGSize(width: 1, height: 1)
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

        guard let context = CGContext(
            data: nil,
            width: Int(targetSize.width),
            height: Int(targetSize.height),
            bitsPerComponent: 8,
            bytesPerRow: Int(targetSize.width) * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: bitmapInfo
        ) else {
            return nil
        }

        context.interpolationQuality = .medium
        context.draw(cgImage, in: CGRect(origin: .zero, size: targetSize))

        guard let pixelBuffer = context.data else { return nil }

        let pixelPointer = pixelBuffer.bindMemory(to: UInt8.self, capacity: 4)

        let redComponent = CGFloat(pixelPointer[0]) / 255.0
        let greenComponent = CGFloat(pixelPointer[1]) / 255.0
        let blueComponent = CGFloat(pixelPointer[2]) / 255.0
        let alphaComponent = CGFloat(pixelPointer[3]) / 255.0

        return UIColor(
            red: redComponent,
            green: greenComponent,
            blue: blueComponent,
            alpha: alphaComponent
        )
    }

    func twoToneGradientColors() -> (UIColor, UIColor)? {
        guard let averageColor = averageColor() else { return nil }

        var hueValue: CGFloat = 0
        var saturationValue: CGFloat = 0
        var brightnessValue: CGFloat = 0
        var alphaValue: CGFloat = 0

        guard averageColor.getHue(
            &hueValue,
            saturation: &saturationValue,
            brightness: &brightnessValue,
            alpha: &alphaValue
        ) else {
            return (averageColor, averageColor)
        }

        let lighterTopColor = UIColor(
            hue: hueValue,
            saturation: min(max(saturationValue * 0.9, 0.2), 1.0),
            brightness: min(brightnessValue * 1.2, 1.0),
            alpha: 1.0
        )

        let darkerBottomColor = UIColor(
            hue: hueValue,
            saturation: min(max(saturationValue * 1.1, 0.25), 1.0),
            brightness: max(brightnessValue * 0.5, 0.1),
            alpha: 1.0
        )

        return (lighterTopColor, darkerBottomColor)
    }

    func threeToneGradientColors() -> [UIColor]? {
        guard let averageColor = averageColor() else { return nil }

        var hueValue: CGFloat = 0
        var saturationValue: CGFloat = 0
        var brightnessValue: CGFloat = 0
        var alphaValue: CGFloat = 0

        guard averageColor.getHue(
            &hueValue,
            saturation: &saturationValue,
            brightness: &brightnessValue,
            alpha: &alphaValue
        ) else {
            return [averageColor, averageColor, averageColor]
        }

        let topColor = UIColor(
            hue: hueValue,
            saturation: min(max(saturationValue * 0.85, 0.18), 1.0),
            brightness: min(brightnessValue * 1.25, 1.0),
            alpha: 1.0
        )

        let middleColor = UIColor(
            hue: hueValue,
            saturation: min(max(saturationValue * 1.0, 0.22), 1.0),
            brightness: min(max(brightnessValue * 0.95, 0.15), 1.0),
            alpha: 1.0
        )

        let bottomColor = UIColor(
            hue: hueValue,
            saturation: min(max(saturationValue * 1.15, 0.28), 1.0),
            brightness: max(brightnessValue * 0.45, 0.08),
            alpha: 1.0
        )

        return [topColor, middleColor, bottomColor]
    }

    func fourToneGradientColors() -> [UIColor]? {
        guard let averageColor = averageColor() else { return nil }

        var hueValue: CGFloat = 0
        var saturationValue: CGFloat = 0
        var brightnessValue: CGFloat = 0
        var alphaValue: CGFloat = 0

        guard averageColor.getHue(
            &hueValue,
            saturation: &saturationValue,
            brightness: &brightnessValue,
            alpha: &alphaValue
        ) else {
            return [averageColor, averageColor, averageColor, averageColor]
        }

        let topColor = UIColor(
            hue: hueValue,
            saturation: min(max(saturationValue * 0.8, 0.18), 1.0),
            brightness: min(brightnessValue * 1.25, 1.0),
            alpha: 1.0
        )

        let upperMiddleColor = UIColor(
            hue: hueValue,
            saturation: min(max(saturationValue * 0.95, 0.20), 1.0),
            brightness: min(max(brightnessValue * 1.05, 0.18), 1.0),
            alpha: 1.0
        )

        let lowerMiddleColor = UIColor(
            hue: hueValue,
            saturation: min(max(saturationValue * 1.1, 0.24), 1.0),
            brightness: max(brightnessValue * 0.75, 0.12),
            alpha: 1.0
        )

        let bottomColor = UIColor(
            hue: hueValue,
            saturation: min(max(saturationValue * 1.2, 0.30), 1.0),
            brightness: max(brightnessValue * 0.45, 0.08),
            alpha: 1.0
        )

        return [topColor, upperMiddleColor, lowerMiddleColor, bottomColor]
    }
}
