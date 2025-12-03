import Foundation
import NetworkLibrary

enum APIDefinitions {
    static let mainDomain = "macmagazine.com.br"
    static let mainURL = "https://\(mainDomain)/"

    static let patraoLoginUrl = "\(mainURL)loginpatrao"
    static let patraoSuccessUrl = "\(mainURL)wp-admin/profile.php"

    static let privacyUrl = "\(mainURL)politica-privacidade/"
    static let termsUrl = "\(mainURL)termos-de-uso/"

    static let feed = "/feed/"
    static let paged = "paged"
    static let cat = "cat"
    static let tag = "tag"
    static let search = "s"

    static let mmlive = "mmlive.json"
}

extension Endpoint {
    static func posts(
        paged: Int = 0,
        query: (String, String)? = nil
    ) -> Self {
        var queryItems = [URLQueryItem(name: APIDefinitions.paged, value: "\(paged)")]
        if let (name, value) = query {
            queryItems.append(URLQueryItem(name: name, value: value))
        }
        return Endpoint(customHost: CustomHost(host: APIDefinitions.mainDomain),
                        api: APIDefinitions.feed,
                        queryItems: queryItems)
    }
}
