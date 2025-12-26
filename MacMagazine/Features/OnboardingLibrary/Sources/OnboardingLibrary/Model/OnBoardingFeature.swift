import SwiftUI

public struct OnBoardingFeature: Identifiable {
    public var id: String = UUID().uuidString
    let symbol: String
    let title: String
    let subTitle: String
}

@MainActor
public extension OnBoardingFeature {
     static let allCards: [OnBoardingFeature] = [
        OnBoardingFeature(
            symbol: "sparkles",
            title: "Nova interface",
            subTitle: "Liquid Glass. Rápido e fácil de usar."
        ),
        OnBoardingFeature(
            symbol: "ipad.and.iphone",
            title: "iPhone e iPad",
            subTitle: "Experiências diferentes, pensadas para cada dispositivo."
        ),
        OnBoardingFeature(
            symbol: "apple.podcasts.pages",
            title: "Experiência em podcasts",
            subTitle: "Controle completo do player. Capítulos."
        ),
        OnBoardingFeature(
            symbol: "photo.on.rectangle.angled",
            title: "Instagram",
            subTitle: "Nova categoria dedicada ao Instagram."
        ),
        OnBoardingFeature(
            symbol: "folder.fill",
            title: "Categorias de posts",
            subTitle: "Explore conteúdos organizados por categorias."
        ),
        OnBoardingFeature(
            symbol: "slider.horizontal.3",
            title: "App personalizável",
            subTitle: "Deixe o app com a sua cara, com ajustes personalizados."
        ),
        OnBoardingFeature(
            symbol: "icloud.fill",
            title: "Sincronização com iCloud",
            subTitle: "Suas preferências sincronizadas em todos os dispositivos."
        ),
        OnBoardingFeature(
            symbol: "applewatch",
            title: "Novo app para Apple Watch",
            subTitle: "Fique informado direto no pulso."
        ),
        OnBoardingFeature(
            symbol: "square.grid.2x2.fill",
            title: "Nova interface de widgets",
            subTitle: "Widgets lindos com design Liquid Glass."
        ),
        OnBoardingFeature(
            symbol: "gift.fill",
            title: "Mais uma novidade",
            subTitle: "Descubra recursos escondidos por todo o app."
        ),
        OnBoardingFeature(
            symbol: "desktopcomputer",
            title: "App para macOS",
            subTitle: "Aplicativo completo para Mac, pensado para o desktop."
        )
    ]
}
