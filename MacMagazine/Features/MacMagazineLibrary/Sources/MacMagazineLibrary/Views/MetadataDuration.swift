import SwiftUI

public struct MetadataDuration: View {
    let text: String

    public init(text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundColor(.white)
            .lineLimit(1)
            .glassEffect(.clear, in: .rect(cornerRadius: 6))
    }
}
