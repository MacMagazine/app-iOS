//
//  Network.swift
//  Piscina
//
//  Created by Cassio Rossi on 28/11/16.
//  Copyright © 2016 Cassio Rossi. All rights reserved.
//

import Foundation

class Network {

	class func getPosts(host: String, query: String, completion: @escaping () -> Void) {
		guard let url = URL(string: "\(host)\(query)") else {
			return
		}

		let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
		defaultSession.dataTask(with: url) { data, response, error in

			if let _ = error {
				completion()

			} else if let httpResponse = response as? HTTPURLResponse {
				if httpResponse.statusCode == 200 {

					do {
						if let data = data, let response = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [Dictionary<String, Any>] {

							self.processJSON(json: response)
							completion()
						}
					} catch {
						completion()
					}

				}
			}
		}.resume()
	}

	class func getImageURL(host: String, query: String, completion: @escaping (String?) -> Void) {
		guard let url = URL(string: "\(host)\(query)") else {
			return
		}

		let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
		defaultSession.dataTask(with: url) { data, response, error in

			if let _ = error {
				completion(nil)

			} else if let httpResponse = response as? HTTPURLResponse {
				if httpResponse.statusCode == 200 {

					do {
						if let data = data, let response = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? Dictionary<String, Any> {

							completion(self.processImageJSON(json: response))
						}
					} catch {
						completion(nil)
					}

				}
			}
			}.resume()
	}

}
