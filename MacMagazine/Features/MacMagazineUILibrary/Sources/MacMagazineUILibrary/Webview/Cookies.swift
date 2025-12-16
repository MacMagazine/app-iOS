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

    public static func createColorSchema(_ value: String) -> HTTPCookie? {
        return HTTPCookie(properties: [
            .domain: mmDomain,
            .path: "/",
            .name: "_color_schema",
            .value: value,
            .secure: "true",
            .expires: NSDate(timeIntervalSinceNow: 60)
        ])
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
    @MainActor
    static func makeCookies(
        darkMode: Bool = true,
        font: String? = nil,
        removeAds: Bool? = false
    ) -> [HTTPCookie] {
        var cookies = [HTTPCookie]()

        if let darkModeCookie = Cookies.createDarkMode(darkMode ? "true" : "false") {
            cookies.append(darkModeCookie)
        }
        if let colorSchemaCookie = Cookies.createColorSchema(darkMode ? "dark" : "light") {
            cookies.append(colorSchemaCookie)
        }

        if let fontCookie = Cookies.createFont(font ?? Self.fontSizeUserAgent) {
            cookies.append(fontCookie)
        }

        if let removeAdsCookie = Cookies.createPurchased(removeAds == true ? "true" : "false") {
            cookies.append(removeAdsCookie)
        }

        return cookies
    }
}

#if os(iOS) || os(visionOS)
import UIKit

private extension Cookies {
    @MainActor
    static var fontSizeUserAgent: String {
        let contentSize: UIContentSizeCategory = UIApplication.shared.preferredContentSizeCategory
        if contentSize == .unspecified {
            return "large"
        }
        let size = contentSize.rawValue.replacingOccurrences(of: "UICTContentSizeCategory", with: "")
            .replacingOccurrences(of: "X", with: "Extra")
            .replacingOccurrences(of: "L", with: "Large")
            .replacingOccurrences(of: "S", with: "Small")
            .replacingOccurrences(of: "M", with: "Medium")
            .llamaCase()

        return size
    }
}
#else
private extension Cookies {
    @MainActor
    static var fontSizeUserAgent: String {
        "large"
    }
}
#endif

extension String {
    func llamaCase() -> String {
        return "\(self.first?.lowercased() ?? "")\(self.dropFirst())"
    }
}
