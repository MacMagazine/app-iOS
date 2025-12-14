import SwiftUI
import UIComponentsLibrary

struct PodcastImageView<Content: View>: View {
    enum ImageLocation {
        case chapter
        case player
        case background
    }
    
    let artworkData: Data?
    let location: ImageLocation
    let fallback: (() -> Content)?
    
    @ViewBuilder
    var body: some View {
        if let artworkData, let uiImage = UIImage(data: artworkData) {
            dataImage(uiImage)
        } else if let artworkURL = URL(string: Constants.coverURL) {
            coverImage(artworkURL)
        } else {
            fallback?()
        }
    }
}

private extension PodcastImageView {
    @ViewBuilder
    func dataImage(_ uiImage: UIImage) -> some View {
        switch location {
        case .player:
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
            
        case .chapter:
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
            
        case .background:
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .overlay(.ultraThinMaterial)
        }
    }
    
    @ViewBuilder
    func coverImage(_ artworkURL: URL) -> some View {
        switch location {
        case .player:
            CachedAsyncImage(image: artworkURL)
            
        case .chapter:
            CachedAsyncImage(image: artworkURL, contentMode: .fill)
                .aspectRatio(contentMode: .fill)
            
        case .background:
            CachedAsyncImage(image: artworkURL, contentMode: .fill)
                .scaledToFill()
                .overlay(.ultraThinMaterial)
        }
    }
}
