import Foundation
import ImageIO
import UniformTypeIdentifiers

/// Shrinks widget thumbnails so timeline entries stay well inside WidgetKit's memory limits.
public enum WidgetImageDownscaler {
    public static let compressionQuality = 0.8

    /// Downscales image data to a compact JPEG whose shorter side is at least `targetPixelSize`.
    ///
    /// The aspect ratio is kept and images already at or below the target are re-encoded, never upscaled.
    /// - Returns: JPEG data, or `nil` when the input can't be decoded.
    public static func downscale(_ data: Data, targetPixelSize: Int) -> Data? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
              let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
              let width = properties[kCGImagePropertyPixelWidth] as? Int,
              let height = properties[kCGImagePropertyPixelHeight] as? Int,
              width > 0, height > 0 else {
            return nil
        }

        let shorterSide = min(width, height)
        let longerSide = max(width, height)
        let maxPixelSize = shorterSide <= targetPixelSize
            ? longerSide
            : Int((Double(targetPixelSize) * Double(longerSide) / Double(shorterSide)).rounded(.up))

        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize
        ]
        guard let image = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
            return nil
        }

        let output = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(output, UTType.jpeg.identifier as CFString, 1, nil) else {
            return nil
        }
        let destinationOptions: [CFString: Any] = [kCGImageDestinationLossyCompressionQuality: compressionQuality]
        CGImageDestinationAddImage(destination, image, destinationOptions as CFDictionary)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return output as Data
    }
}
