//
//  PostData.swift
//  MacMagazineWidgetExtensionExtension
//
//  Created by Ailton Vieira Pinto Filho on 16/01/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import Foundation

extension PostData {
    static var placeholder = PostData(title: "Acompanhe as últimas notícias do universo Apple.",
                                      link: "",
                                      thumbnail: "",
                                      favorito: false,
                                      pubDate: "",
                                      excerpt: "Adicione o widget à tela inicial do seu dispositivo.",
                                      postId: "",
                                      shortURL: "")

    var url: URL {
        return URL(staticString: link ?? "")
    }
}

extension URL {
    init(staticString string: String) {
        self = URL(string: "\(string)") ?? URL(staticString: "widget://")
    }
}
