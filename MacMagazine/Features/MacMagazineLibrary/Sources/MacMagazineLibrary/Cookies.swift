import Foundation

public struct Cookies {

    static let disqus = "disqus.com"
    static let mmDomain = "macmagazine.com.br"

    public static func get(_ domain: String? = nil) -> [HTTPCookie]? {
        let cookies = HTTPCookieStorage.shared.cookies

        guard let domain = domain else {
            return cookies
        }

        return cookies?.filter {
            return $0.domain.contains(domain)
        }
    }

    public static func clean() {
        for cookie in Self.get() ?? [] {
            if !cookie.domain.contains(disqus) &&
                !cookie.domain.contains(mmDomain) {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }

    public static func createDarkMode(_ value: String) -> HTTPCookie? {
        return HTTPCookie(properties: [
            .domain: mmDomain,
            .path: "/",
            .name: "darkmode",
            .value: value,
            .secure: "true",
            .expires: NSDate(timeIntervalSinceNow: 60)
        ])
    }

    public static func createFont(_ value: String) -> HTTPCookie? {
        return HTTPCookie(properties: [
            .domain: mmDomain,
            .path: "/",
            .name: "fonte",
            .value: value,
            .secure: "true",
            .expires: NSDate(timeIntervalSinceNow: 60)
        ])
    }

    public static func createVersion(_ value: String) -> HTTPCookie? {
        return HTTPCookie(properties: [
            .domain: mmDomain,
            .path: "/",
            .name: "version",
            .value: value,
            .secure: "true",
            .expires: NSDate(timeIntervalSinceNow: 60)
        ])
    }

    public static func createPurchased(_ value: String) -> HTTPCookie? {
        return HTTPCookie(properties: [
            .domain: mmDomain,
            .path: "/",
            .name: "patr",
            .value: value,
            .secure: "true",
            .expires: NSDate(timeIntervalSinceNow: 60)
        ])
    }
}

public extension Cookies {
    static func makeCookies(darkMode: Bool?) -> [HTTPCookie] {
        var cookies = [HTTPCookie]()
        if let darkMode,
           let darkModeCookie = Cookies.createDarkMode(darkMode ? "true" : "false") {
            cookies.append(darkModeCookie)
        }
        return cookies
    }
}
