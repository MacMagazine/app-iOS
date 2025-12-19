import UIKit

extension UIColor {
    var perceivedBrightness: CGFloat {
        var redComponent: CGFloat = 0
        var greenComponent: CGFloat = 0
        var blueComponent: CGFloat = 0
        var alphaComponent: CGFloat = 0

        guard getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha: &alphaComponent) else {
            return 0.5
        }

        let brightness =
        (redComponent * 299) +
        (greenComponent * 587) +
        (blueComponent * 114)

        return brightness / 1000
    }
}
