//
//  PostData.swift
//  MacMagazineWidgetExtensionExtension
//
//  Created by Ailton Vieira Pinto Filho on 16/01/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import Foundation

extension PostData {
    static var placeholder = PostData(title: "MacMagazine",
                                      link: "",
                                      thumbnail: "",
                                      favorito: false,
                                      pubDate: "",
                                      excerpt: "Confira nossos últimos posts!",
                                      postId: "",
                                      shortURL: "")

    var url: URL? {
        guard let link = link,
              let url = URL(string: link) else {
            return nil
        }
        return url
    }
}
