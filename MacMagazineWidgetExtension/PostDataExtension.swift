//
//  PostData.swift
//  MacMagazineWidgetExtensionExtension
//
//  Created by Ailton Vieira Pinto Filho on 16/01/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import Foundation

extension PostData {
    static var placeholder: PostData { .init(title: "Acompanhe as notícias do App MacMagazine",
                                             link: "",
                                             thumbnail: "",
                                             favorito: false,
                                             pubDate: "",
                                             excerpt: "Adicione o widget à tela inicial do seu dispositivo.",
                                             postId: "",
                                             shortURL: "",
                                             imageData: nil) }
}
