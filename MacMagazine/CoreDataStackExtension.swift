//
//  CoreDataStack.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 23/03/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import CoreData
import Foundation

extension CoreDataStack {

    // MARK: - Entity Video -

    func get(video videoId: String, completion: @escaping ([Video]) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: videoEntityName)
        request.predicate = NSPredicate(format: "videoId == %@", videoId)

        // Creates `asynchronousFetchRequest` with the fetch request and the completion closure
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: request) { asynchronousFetchResult in
            guard let result = asynchronousFetchResult.finalResult as? [Video] else {
                completion([])
                return
            }
            completion(result)
        }

        do {
            try viewContext.execute(asynchronousFetchRequest)
        } catch let error {
            logE(error.localizedDescription)
        }
    }

    func save(playlist: YouTube<String>, statistics: [Item<String>]) {
        // Cannot duplicate videos
        guard let videos = playlist.items else {
            return
        }

        let mappedVideos: [JSONVideo] = videos.compactMap {
            guard let title = $0.snippet?.title,
                let videoId = $0.snippet?.resourceId?.videoId
                else {
                    return nil
            }

            var likes = ""
            var views = ""
            var duration = ""
            let stat = statistics.filter {
                $0.id == videoId
            }
            if !stat.isEmpty {
                views = stat[0].statistics?.viewCount ?? ""
                likes = stat[0].statistics?.likeCount ?? ""
                duration = stat[0].contentDetails?.duration ?? ""
            }

            let artworkURL = $0.snippet?.thumbnails?.maxres?.url ?? $0.snippet?.thumbnails?.high?.url ?? ""

            // swiftlint:disable vertical_parameter_alignment_on_call
            return JSONVideo(title: title,
                             videoId: videoId,
                             pubDate: $0.contentDetails?.videoPublishedAt ?? $0.snippet?.publishedAt ?? "",
                             artworkURL: artworkURL,
                             views: views,
                             likes: likes,
                             duration: duration)
            // swiftlint:disable vertical_parameter_alignment_on_call
        }

        mappedVideos.forEach { video in
            get(video: video.videoId) { items in
                if items.isEmpty {
                    self.insert(video: video)
                } else {
                    self.update(video: items[0], with: video)
                }
                self.save()
            }
        }
    }

    func insert(video: JSONVideo) {
        let newItem = Video(context: viewContext)
        newItem.favorite = false
        newItem.title = video.title
        newItem.artworkURL = video.artworkURL.escape()
        newItem.pubDate = video.pubDate.toDate(Format.youtube)
        newItem.videoId = video.videoId
        newItem.likes = video.likes
        newItem.views = video.views
        newItem.duration = video.duration
    }

    func update(video: Video, with item: JSONVideo) {
        video.title = item.title
        video.artworkURL = item.artworkURL.escape()
        video.pubDate = item.pubDate.toDate(Format.youtube)
        video.videoId = item.videoId
        video.likes = item.likes
        video.views = item.views
        video.duration = item.duration
    }
}
