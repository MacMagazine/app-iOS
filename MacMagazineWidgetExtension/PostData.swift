//
//  PostData.swift
//  MacMagazineWidgetExtensionExtension
//
//  Created by Ailton Vieira Pinto Filho on 16/01/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import Foundation

struct PostData: Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let image: Data?
    let pubDate: String
    
    static var placeholder: PostData { .init(id: "", title: "Agora o aplicativo do MacMagazine tem widgets para você adicionar à tela inicial do seu iPhone", description: "Descrição", image: nil, pubDate: "") }
}
