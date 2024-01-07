import SwiftUI
import UIComponentsLibrary

struct ImageView: View {
	private let url: URL
	private let height: CGFloat
	private let overlay: Bool

	init?(url: URL?,
		  height: CGFloat = .infinity,
		  aspectRatio: CGFloat = 9 / 16,
		  overlay: Bool = false) {
		guard let url = url else { return nil }
		self.url = url
		self.height = height * aspectRatio
		self.overlay = overlay
	}

	public var body: some View {
		CachedAsyncImage(image: url, contentMode: .fill)
			.frame(height: height)
			.cornerRadius(12, corners: .allCorners)
			.if(overlay) { content in
				content
					.overlay {
						Rectangle().fill(.black).opacity(0.45)
							.frame(height: height)
							.cornerRadius(12, corners: .allCorners)
					}
			}
	}
}

#Preview {
	ImageView(url: URL(string: "MacMagazine"))
}
