//
//  RecentPostsProvider.swift
//  MacMagazineWidgetExtensionExtension
//
//  Created by Ailton Vieira Pinto Filho on 16/01/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import Foundation
import Kingfisher
import WidgetKit

struct RecentPostsProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> RecentPostsEntry {
        RecentPostsEntry(date: Date(), configuration: ConfigurationIntent(), posts: [.placeholder, .placeholder, .placeholder])
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (RecentPostsEntry) -> Void) {
        let entry = RecentPostsEntry(date: Date(), configuration: configuration, posts: [.placeholder, .placeholder, .placeholder, .placeholder])
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<RecentPostsEntry>) -> Void) {
        var posts: Set<PostData> = []

        let group = DispatchGroup()

        API().getPosts(page: 0) { xmlPost in
            guard let xmlPost = xmlPost else {
                group.wait()

                let currentDate = Date()
                guard let nextDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate) else {
                    completion(.init(entries: [], policy: .atEnd))
                    return
                }

                let entry = RecentPostsEntry(date: currentDate, configuration: configuration, posts: posts.sorted(by: { $0.pubDate ?? "" > $1.pubDate ?? "" }))

                let timeline = Timeline(entries: [entry], policy: .after(nextDate))
                completion(timeline)
                return
            }
            DispatchQueue.global().async {
                guard let url = URL(string: xmlPost.artworkURL) else {
                    return
                }
                group.enter()
                KingfisherManager.shared.retrieveImage(with: url, options: nil) { result in
                    if case let .success(imageResult) = result {
                        print("ok")
                        let post = PostData(title: xmlPost.title,
                                            link: xmlPost.link,
                                            thumbnail: xmlPost.artworkURL,
                                            favorito: xmlPost.favorite,
                                            pubDate: xmlPost.pubDate,
                                            excerpt: xmlPost.excerpt,
                                            postId: xmlPost.postId,
                                            shortURL: xmlPost.shortURL,
                                            imageData: imageResult.image.pngData())
                        posts.insert(post)
                        group.leave()
                    }
                }
            }
        }
    }
}
