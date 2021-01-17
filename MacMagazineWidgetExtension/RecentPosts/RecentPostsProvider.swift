//
//  RecentPostsProvider.swift
//  MacMagazineWidgetExtensionExtension
//
//  Created by Ailton Vieira Pinto Filho on 16/01/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import Foundation
import WidgetKit

struct RecentPostsProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> RecentPostsEntry {
        RecentPostsEntry(date: Date(), configuration: ConfigurationIntent(), posts: [.placeholder, .placeholder, .placeholder])
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (RecentPostsEntry) -> ()) {
        let entry = RecentPostsEntry(date: Date(), configuration: configuration, posts: [.placeholder, .placeholder, .placeholder, .placeholder])
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<RecentPostsEntry>) -> ()) {
        var posts: Set<PostData> = []
        
        let group = DispatchGroup()
        
        API().getPosts(page: 1) { xmlPost in
            guard let xmlPost = xmlPost else {
                group.wait()
                
                let currentDate = Date()
                let nextDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
                
                let entry = RecentPostsEntry(date: currentDate, configuration: configuration, posts: posts.sorted(by: { $0.pubDate > $1.pubDate }))

                let timeline = Timeline(entries: [entry], policy: .after(nextDate))
                completion(timeline)
                return
            }
            DispatchQueue.global().async {
                guard let url = URL(string: xmlPost.artworkURL) else { return }
                group.enter()
                ImageLoader.load(url: url) { data in
                    if let data = data {
                        let post = PostData(id: xmlPost.postId, title: xmlPost.title, description: xmlPost.excerpt, image: data, pubDate: xmlPost.pubDate)
                        posts.insert(post)
                    }
                    group.leave()
                }
            }
        }
    }
    
    
}
