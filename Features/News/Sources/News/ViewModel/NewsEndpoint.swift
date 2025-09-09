import CommonLibrary
import CoreLibrary
import Foundation

extension Endpoint {
	static func posts(customHost: CustomHost? = nil, paged: Int = 0, query: (String, String)? = nil) -> Self {
		var queryItems = [URLQueryItem(name: APIParams.paged, value: "\(paged)")]
		if let (name, value) = query {
			queryItems.append(URLQueryItem(name: name, value: value))
		}
		return Endpoint(customHost: customHost ?? CustomHost(host: APIParams.mainDomain),
						api: customHost?.api ?? APIParams.feed,
						queryItems: queryItems)
	}
}
