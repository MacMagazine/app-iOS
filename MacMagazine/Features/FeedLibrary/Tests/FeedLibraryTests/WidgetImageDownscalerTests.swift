import CoreGraphics
@testable import FeedLibrary
import Foundation
import ImageIO
import Testing
import UniformTypeIdentifiers

@Suite("WidgetImageDownscaler Tests")
struct WidgetImageDownscalerTests {

    // MARK: - Downscaling Tests

    @Test("Large landscape image is downscaled to fill the target")
    func downscalesLargeLandscapeImage() throws {
        // Given
        let input = try makePNG(width: 2000, height: 1000)

        // When
        let output = try #require(WidgetImageDownscaler.downscale(input, targetPixelSize: 500))

        // Then
        let size = try pixelSize(of: output)
        let shorterSide = min(size.width, size.height)
        #expect(shorterSide >= 500)
        #expect(shorterSide < 1000)
        let ratio = Double(size.width) / Double(size.height)
        #expect(abs(ratio - 2.0) / 2.0 < 0.01)
        #expect(try imageType(of: output) == UTType.jpeg.identifier)
    }

    @Test("Small image is re-encoded but not upscaled")
    func doesNotUpscaleSmallImage() throws {
        // Given
        let input = try makePNG(width: 100, height: 50)

        // When
        let output = try #require(WidgetImageDownscaler.downscale(input, targetPixelSize: 500))

        // Then
        let size = try pixelSize(of: output)
        #expect(size.width == 100)
        #expect(size.height == 50)
        #expect(try imageType(of: output) == UTType.jpeg.identifier)
    }

    @Test("Undecodable data returns nil")
    func undecodableDataReturnsNil() {
        // Given
        let input = Data("not an image".utf8)

        // When
        let output = WidgetImageDownscaler.downscale(input, targetPixelSize: 500)

        // Then
        #expect(output == nil)
    }

    @Test("Empty data returns nil")
    func emptyDataReturnsNil() {
        #expect(WidgetImageDownscaler.downscale(Data(), targetPixelSize: 500) == nil)
    }
}

// MARK: - Helpers

private extension WidgetImageDownscalerTests {
    struct FixtureError: Error {}

    func makePNG(width: Int, height: Int) throws -> Data {
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { throw FixtureError() }
        context.setFillColor(CGColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1))
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))
        guard let image = context.makeImage() else { throw FixtureError() }

        let output = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(output, UTType.png.identifier as CFString, 1, nil) else {
            throw FixtureError()
        }
        CGImageDestinationAddImage(destination, image, nil)
        guard CGImageDestinationFinalize(destination) else { throw FixtureError() }
        return output as Data
    }

    func pixelSize(of data: Data) throws -> (width: Int, height: Int) {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
              let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
              let width = properties[kCGImagePropertyPixelWidth] as? Int,
              let height = properties[kCGImagePropertyPixelHeight] as? Int else {
            throw FixtureError()
        }
        return (width, height)
    }

    func imageType(of data: Data) throws -> String {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
              let type = CGImageSourceGetType(source) else {
            throw FixtureError()
        }
        return type as String
    }
}
