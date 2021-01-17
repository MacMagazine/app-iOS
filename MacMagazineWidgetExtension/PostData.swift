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
    let image: Data?
    let pubDate: String
    
    static var placeholder: PostData { .init(id: "", title: "Título do Conteúdo", image: nil, pubDate: "") }
}
