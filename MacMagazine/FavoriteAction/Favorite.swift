//
//  Favorite.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 15/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import Foundation

struct Favorite {

	func updatePostStatus(using link: String, _ completion: ((Bool) -> Void)? = nil) {
        CoreDataStack.shared.get(link: link) { (items: [Post]) in
			if !items.isEmpty {
				items[0].favorite = !items[0].favorite
				CoreDataStack.shared.save()
				completion?(items[0].favorite)
			}
		}
	}

	func updateVideoStatus(using videoId: String?, _ completion: ((Bool) -> Void)? = nil) {
		guard let videoId = videoId else {
			completion?(false)
			return
		}
		CoreDataStack.shared.get(video: videoId) { items in
			if !items.isEmpty {
				items[0].favorite = !items[0].favorite
				CoreDataStack.shared.save()
				completion?(items[0].favorite)
			}
		}
	}

}
