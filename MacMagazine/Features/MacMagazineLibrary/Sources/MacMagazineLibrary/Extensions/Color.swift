import SwiftUI

public extension Color {

    func idealTextColor() -> Color {
        guard let components = UIColor(self).cgColor.components else {
            return .black
        }

        let red = Double(components[0])
        let green = Double(components[1])
        let blue = Double(components[2])

        let brightness =
        (red * 299) +
        (green * 587) +
        (blue * 114)

        return brightness < 0.6 ? .white : .black
    }
}

public extension UIColor {
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
