import Foundation
import NetworkLibrary

enum APIDefinitions {
    static let mainDomain = "macmagazine.com.br"
    static let mmlive = "/mmlive.json"
}

extension Endpoint {
    static func mmLive() -> Self {
        Endpoint(customHost: CustomHost(host: APIDefinitions.mainDomain),
                 api: APIDefinitions.mmlive)
    }
}
