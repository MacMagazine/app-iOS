//
//  Network.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 28/11/16.
//  Copyright © 2016 Cassio Rossi. All rights reserved.
//

import Foundation

enum RestAPIError: Error {
    case network
    case decoding

    var reason: String {
        switch self {
            case .network:
                return "An error occurred while fetching data"
            case .decoding:
                return "An error occurred while decoding data"
        }
    }
}

class Network {

    class func get<T>(url: URL,
                      completion: @escaping (Result<T, RestAPIError>) -> Void) {

        let request = self.setHeaders(url: url, method: "GET")

        let configuration = URLSessionConfiguration.ephemeral
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        let defaultSession = URLSession(configuration: configuration)
        defaultSession.dataTask(with: request) { data, response, _ in

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.hasSuccessStatusCode,
                  let data = data as? T else {
                completion(Result.failure(RestAPIError.network))
                return
            }
            completion(Result.success(data))

        }.resume()
    }

	class func getVdeos<T>(url: URL, completion: @escaping (Result<T, RestAPIError>) -> Void) {

		var request = URLRequest(url: url)
		request.httpMethod = "GET"

        let configuration = URLSessionConfiguration.ephemeral
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        let defaultSession = URLSession(configuration: configuration)
		defaultSession.dataTask(with: request) { data, response, _ in

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.hasSuccessStatusCode,
                  let data = data as? T else {
                completion(Result.failure(RestAPIError.network))
                return
            }
            completion(Result.success(data))

		}.resume()
	}
}

extension Network {
    static func setHeaders(url: URL, method: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Feedburner", forHTTPHeaderField: "User-Agent")
        return request
    }
}

extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
