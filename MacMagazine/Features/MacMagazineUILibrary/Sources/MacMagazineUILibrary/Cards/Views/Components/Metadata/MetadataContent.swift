import SwiftUI

public struct MetadataContent: View {
    let image: String
    let text: String

    public init(image: String, text: String) {
        self.image = image
        self.text = text
    }

    public var body: some View {
        Label(text, systemImage: image)
    }
}
