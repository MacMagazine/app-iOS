//
//  API+XML.swift
//  MMAPI
//
//  Created by Luis Amorim on 27/11/25.
//

import Foundation

public extension API {
    func fetchXMLFeed() async throws -> [XMLPost] {
        guard let url = URL(string: feed) else { throw APIError.invalidURL }
        let data = try await Network.get(url: url)
        return try parseXMLPosts(from: data)
    }
    
    func fetchPodcastFeed() async throws -> [XMLPost] {
        guard let url = URL(string: podcastFeed) else { throw APIError.invalidURL }
        let data = try await Network.get(url: url)
        return try parseXMLPosts(from: data)
    }
}
