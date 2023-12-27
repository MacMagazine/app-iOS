import CommonLibrary
import CoreLibrary
import Foundation

extension Endpoint {
	static func posts(customHost: CustomHost? = nil, paged: Int = 0) -> Self {
		return Endpoint(customHost: customHost ?? CustomHost(host: APIParams.mainDomain),
						api: customHost?.api ?? APIParams.feed,
						queryItems: [URLQueryItem(name: APIParams.paged, value: "\(paged)")])
	}
}
