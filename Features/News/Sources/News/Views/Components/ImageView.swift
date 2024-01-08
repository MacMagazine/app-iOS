import SwiftUI
import UIComponentsLibrary

struct ImageView: View {
	enum Style {
		case followRatio
		case followRatioWithOverlay
		case fullWidth
	}

	private let url: URL
	private let width: CGFloat
	private let height: CGFloat
	private let aspectRatio: CGFloat
	private let style: Style

	init?(style: Style = .followRatioWithOverlay,
		  url: URL?,
		  width: CGFloat = .infinity,
		  height: CGFloat? = nil,
		  aspectRatio: CGFloat = 16 / 9) {
		guard let url = url else { return nil }
		self.url = url
		self.width = width
		self.height = height ?? (width / aspectRatio)
		self.aspectRatio = aspectRatio
		self.style = style
	}

	public var body: some View {
		switch style {
		case .followRatio: followRatioView
		case .followRatioWithOverlay: followRatioWithOverlayView
		case .fullWidth: fullWidthView
		}
	}
}

extension ImageView {
	@ViewBuilder
	private var followRatioView: some View {
		CachedAsyncImage(image: url, contentMode: .fill)
			.frame(width: width, height: height)
			.cornerRadius(12, corners: .allCorners)
	}

	@ViewBuilder
	private var followRatioWithOverlayView: some View {
		CachedAsyncImage(image: url, contentMode: .fill)
					.overlay {
						Rectangle().fill(.black).opacity(0.45)
					}
			.frame(width: width, height: height)
			.cornerRadius(12, corners: .allCorners)
	}

	@ViewBuilder
	private var fullWidthView: some View {
		Rectangle().fill(Color(.gray))
			.frame(height: height)
			.overlay {
				CachedAsyncImage(image: url, contentMode: .fill)
			}
			.cornerRadius(12, corners: .allCorners)
			.clipped()
	}
}

#Preview {
	ImageView(url: URL(string: "MacMagazine"))
}
