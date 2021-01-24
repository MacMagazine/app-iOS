//
//  RecentPostsEntry.swift
//  MacMagazineWidgetExtensionExtension
//
//  Created by Ailton Vieira Pinto Filho on 16/01/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import Foundation
import WidgetKit

struct RecentPostsEntry: TimelineEntry {
    let date: Date
    let posts: [PostData]
}
