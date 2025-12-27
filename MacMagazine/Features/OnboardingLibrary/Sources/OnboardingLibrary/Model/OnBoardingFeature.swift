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
            subTitle: "Liquid Glass. Rápida, moderna e fácil de usar."
        ),
        OnBoardingFeature(
            symbol: "ipad.and.iphone",
            title: "Dispositivos suportados",
            subTitle: "iPhone, iPad, Mac e Apple Watch"
        ),
        OnBoardingFeature(
            symbol: "apple.podcasts.pages",
            title: "MacMagazine no Ar",
            subTitle: "Player completo para o nosso podcast, com suporte a capítulos."
        ),
        OnBoardingFeature(
            symbol: "photo.on.rectangle.angled",
            title: "Instagram",
            subTitle: "Nova aba dedicada à rede social."
        ),
//        OnBoardingFeature(
//            symbol: "folder.fill",
//            title: "Categorias de posts",
//            subTitle: "Explore conteúdos organizados por categorias."
//        ),
        OnBoardingFeature(
            symbol: "slider.horizontal.3",
            title: "App personalizável",
            subTitle: "Deixe o app com a sua cara!"
        ),
        OnBoardingFeature(
            symbol: "icloud.fill",
            title: "Sincronização com iCloud",
            subTitle: "Preferências sincronizadas em todos os seus dispositivos."
        ),
        OnBoardingFeature(
            symbol: "applewatch",
            title: "Novo app para Apple Watch",
            subTitle: "Fique informado diretamente no pulso."
        ),
        OnBoardingFeature(
            symbol: "square.grid.2x2.fill",
            title: "Widgets lindos…",
            subTitle: "Três tamanhos de widgets para você escolher."
        )
//        OnBoardingFeature(
//            symbol: "gift.fill",
//            title: "Mais uma novidade",
//            subTitle: "Descubra recursos escondidos por todo o app."
//        ),
//        OnBoardingFeature(
//            symbol: "desktopcomputer",
//            title: "App para macOS",
//            subTitle: "Aplicativo completo para Mac, pensado para o desktop."
//        )
    ]
}
