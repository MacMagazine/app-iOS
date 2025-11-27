//
//  API+JSON.swift
//  MMAPI
//
//  Created by Luis Amorim on 27/11/25.
//

import Foundation

public extension API {
    func getPosts(page: Int = 1) async throws -> Data {
        guard let url = URL(string: "\(json)1&page=\(page)") else {
            throw APIError.invalidURL
        }
        return try await Network.get(url: url)
    }
    
    func searchPosts(_ text: String) async throws -> Data {
        let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? text
        guard let url = URL(string: "\(json)get_search_results&search=\(query)") else {
            throw APIError.invalidURL
        }
        return try await Network.get(url: url)
    }
    
    func getPost(id: Int) async throws -> Data {
        guard let url = URL(string: "\(json)get_post&id=\(id)") else {
            throw APIError.invalidURL
        }
        return try await Network.get(url: url)
    }
}
