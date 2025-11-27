//
//  Network.swift
//  MMAPI
//
//  Created by Luis Amorim on 27/11/25.
//

import Foundation

public enum NetworkError: Error {
    case invalidResponse
    case network
}

public enum APIError: Error {
    case invalidURL
    case network
    case decoding
    case xmlParsing
}

public struct Network {
    
    public static func get(url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse,
              200...299 ~= http.statusCode else {
            throw APIError.network
        }
        return data
    }
    
    // Compatibility for iOS 13/14, macOS 10.15/11
    private static func dataCompat(for request: URLRequest) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let data, let http = response as? HTTPURLResponse, 200...299 ~= http.statusCode else {
                    continuation.resume(throwing: APIError.network)
                    return
                }
                continuation.resume(returning: data)
            }
            task.resume()
        }
    }
}
