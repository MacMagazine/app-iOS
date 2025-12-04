import SwiftUI
import StorageLibrary
import UtilityLibrary
import YouTubeLibrary
import UIKit
import MacMagazineLibrary

@MainActor
struct GlassCardView: View {
    @Namespace var namespace
    @Environment(\.sizeCategory) private var sizeCategory

    let data: VideoDB
    let buttonColor: Color?
    
    @State private var cardWidth: CGFloat = 0
    @State private var thumbnailSize: CGSize = .zero


    var isAccessibilityCategory: Bool {
        sizeCategory.isAccessibilityCategory
    }

    private var density: CardDensity { .from(width: cardWidth) }
   
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            cardBase
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text(accessibilityLabelText))
                .accessibilityAddTraits(.isButton)
            
            topButtons
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear { cardWidth = geo.size.width }
                    .onChange(of: geo.size) { _, newValue in
                        cardWidth = newValue.width
                    }
            }
        )
    }
    
    
    // MARK: - Card base (thumbnail + conteúdo inferior)
    
    private var cardBase: some View {
        Group {
            if let imageUrl = data.url {
                ZStack(alignment: .bottom) {
                    thumbnail(imageUrl)
                    content
                }
            } else {
                content
                    .background(fallbackBackground)
            }
        }
    }
    
    
    // MARK: - Thumbnail
    
    private func thumbnail(_ imageUrl: URL) -> some View {
        Thumbnail(
            imageUrl: imageUrl,
            duration: "",
            position: .none,
            corners: [.allCorners]
        )
        .background(
            GeometryReader { g in
                Color.clear
                    .onAppear { thumbnailSize = g.size }
                    .onChange(of: g.size) { _, newSize in
                        thumbnailSize = newSize
                    }
            }
        )
    }
    
    
    // MARK: - Botões de topo
    
    private var topButtons: some View {
        VStack {
            GlassEffectContainer {
                HStack(spacing: 10) {
                    GlassFavoriteButton(content: data, tint: .primary)
                        .accessibilityLabel(
                            Text(data.favorite
                                 ? "Remover \(data.title) dos favoritos"
                                 : "Adicionar \(data.title) aos favoritos")
                        )
                        .accessibilityAddTraits(.isButton)

                    GlassShareButton(content: data, tint: .primary)
                        .accessibilityLabel(Text("Compartilhar vídeo \(data.title)"))
                        .accessibilityAddTraits(.isButton)
                }
                .glassEffectUnion(id: 1, namespace: namespace)
            }
        }
        .padding(10)
        // Importante: NÃO agrupar isso com o card base
        .accessibilityElement(children: .contain)
    }
    
    
    // MARK: - Fundo fallback (sem imagem)
    
    private var fallbackBackground: LinearGradient { .fallbackBackground }
    
    
    // MARK: - Bloco de conteúdo inferior
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            if density != .spacious {
                dateRow
                    .font(.caption2)
                    .dynamicTypeSize(.xSmall ... .xxLarge)
                    .foregroundStyle(.white.opacity(0.9))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .shadow(color: .white.opacity(0.6), radius: 2, x: 0, y: 1)
            }
            
            Text(data.title)
                .font(density.titleFont)
                .multilineTextAlignment(.leading)
                .lineLimit(density.titleLineLimit)
                .foregroundStyle(.white)
                .shadow(color: .white.opacity(0.6), radius: 2, x: 0, y: 1)

            HStack(alignment: .firstTextBaseline, spacing: 8) {

                if density == .spacious {
                    dateRow
                        .foregroundStyle(.white.opacity(0.9))
                        .shadow(color: .white.opacity(0.6), radius: 2, x: 0, y: 1)
                }

                Group {
                    if isAccessibilityCategory {
                        VStack(alignment: .leading, spacing: 4) {
                            statsRowViews
                            statsRowLikes
                        }
                    } else {
                        HStack(spacing: 8) {
                            statsRowViews
                            statsRowLikes
                        }
                    }
                }
                .foregroundStyle(.white.opacity(0.9))
                .shadow(color: .white.opacity(0.6), radius: 2, x: 0, y: 1)

                Spacer(minLength: 8)

                durationBadge
            }
            .font(.caption2)
            .dynamicTypeSize(.xSmall ... .xxLarge)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .padding(.top, density == .compact ? 20 : 30)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(gradientOverlay)
    }
    
    private var gradientOverlay: LinearGradient { .gradientOverlay }
    
    private var dateRow: some View {
        HStack(spacing: 4) {
            Image(systemName: "calendar")
            Text(data.pubDate.formattedDate(using: "dd/MM/yy"))
        }
    }
    
    private var statsRowViews: some View {
        HStack(spacing: 4) {
            Image(systemName: "chart.bar")
            Text(data.views.formattedBigNumber)
        }
    }

    private var statsRowLikes: some View {
        HStack(spacing: 4) {
            Image(systemName: "hand.thumbsup")
            Text(data.likes.formattedBigNumber)
        }
    }
    
    private var durationBadge: some View {
        Text(data.duration.formattedYTDuration)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundColor(.white)
            .dynamicTypeSize(.xSmall ... .xxLarge)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .glassEffect(.clear, in: .rect(cornerRadius: 6))
    }
}


// MARK: - Acessibilidade (texto falado do card)

private extension GlassCardView {
    var formattedDate: String { data.formattedDateShort }

    var viewsText: String { data.viewsText }
    var likesText: String { data.likesText }

    var durationText: String {
        "Duração de \(AccessibilityUtils.spokenDuration(from: data.duration.formattedYTDuration))"
    }

    var progressText: String? {
        guard data.current > 0 else { return nil }
        return "Vídeo em andamento"
    }

    var favoriteText: String? {
        guard data.favorite else { return nil }
        return "Marcado como favorito"
    }

    var accessibilityLabelText: String {
        AccessibilityUtils.join([
            data.title,
            "Publicado em \(formattedDate)",
            viewsText,
            likesText,
            durationText,
            progressText,
            favoriteText
        ])
    }
}


#if DEBUG
@MainActor
struct MMVideoDBPreview {
    static let sample = VideoDB(
        artworkURL: "https://i.ytimg.com/vi/bq02LMjcCns/maxresdefault.jpg",
        current: 42.0,
        duration: "PT4M46S".formattedYTDuration,
        favorite: true,
        likes: "782",
        pubDate: "2021-02-17T20:45:21Z",
        title: "Como Usar WhatsApp No iPad",
        videoId: "VVVBel9Fc3prM1lqcVZMdzZvWGJTS1FBLmJxMDJMTWpjQ25z",
        views: "5663"
    )
}

#Preview {
    ZStack {
        Color.brown.ignoresSafeArea()
        VStack(spacing: 30) {
            GlassCardView(
                data: MMVideoDBPreview.sample,
                buttonColor: nil
            )
            .frame(width: 320)
            .padding()
            
            GlassCardView(
                data: MMVideoDBPreview.sample,
                buttonColor: nil
            )
            .frame(width: 240)
            .padding()
        }
    }
}
#endif

