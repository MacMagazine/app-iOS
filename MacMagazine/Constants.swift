//
//  Constants.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 03/09/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import Foundation

enum Site: String {
	case protocolo = "https://"
	case url = "macmagazine.uol.com.br"
	case api = "/wp-json/wp/v2/"
	case search = "per_page=1&page=1"
	case posts
	case artworkURL
	case perPage, page

	func withParameter(_ number: Int?) -> String {
		switch self {

		case .posts:
			return "\(Site.protocolo.withParameter(nil))\(Site.url.withParameter(nil))\(Site.api.withParameter(nil))posts?"

		case .artworkURL:
			return "\(Site.protocolo.withParameter(nil))\(Site.url.withParameter(nil))\(Site.api.withParameter(nil))media/"

		case .perPage:
			return "per_page=\(number ?? 0)"

		case .page:
			return "page=\(number ?? 0)"

		default:
			return self.rawValue
		}
	}
}

enum Categoria: Int {
	case destaque = 674
	case podcast = 101
}
