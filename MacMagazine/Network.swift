//
//  Network.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 28/11/16.
//  Copyright © 2016 Cassio Rossi. All rights reserved.
//

import Foundation

struct RestAPIError: Codable {
    var errorCode: String
    var message: String
}

class Network {

    class func get<T>(url: URL, completion: @escaping (T?, String?) -> Void) {

        let request = self.setHeaders(url: url, method: "GET")

        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        defaultSession.dataTask(with: request) { data, _, error in

            guard data != nil && error == nil else {
                completion(nil, error?.localizedDescription)
                return
            }
            completion(data as? T, nil)

        }.resume()
    }

	class func getVdeos<T>(url: URL, completion: @escaping (T?, String?) -> Void) {

		var request = URLRequest(url: url)
		request.httpMethod = "GET"

		let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
		defaultSession.dataTask(with: request) { data, _, error in

			guard data != nil && error == nil else {
				completion(nil, error?.localizedDescription)
				return
			}
			completion(data as? T, nil)

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
