//
//  Constants.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 03/09/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import Foundation

enum Site: String {
	case protocolo, url, api
	case posts
	case perPage, page
	case search
	
	func withParameter(_ number: Int?) -> String {
		switch self {

		case .protocolo:
			return "https://"

		case .url:
			return "macmagazine.com.br"

		case .api:
			return "/wp-json/wp/v2/"

		case .posts:
			return "\(Site.protocolo.withParameter(nil))\(Site.url.withParameter(nil))\(Site.api.withParameter(nil))posts?"

		case .perPage:
			return "per_page=\(number!)"

		case .page:
			return "page=\(number!)"

		case .search:
			return "per_page=1&page=1"
		}
	}
}
