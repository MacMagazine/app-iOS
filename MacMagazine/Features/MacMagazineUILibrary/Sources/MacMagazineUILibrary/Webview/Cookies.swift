import Foundation
@preconcurrency import WebKit

public struct Cookies {

    static let disqus = "disqus.com"
    static let mmDomain = "macmagazine.com.br"
    private static let cookieExpiration: TimeInterval = 86_400

    private static let disqusCookiesKey = "disqus_saved_cookies"

    // MARK: - Disqus Cookie Persistence

    /// Saves Disqus-related cookies from a WKHTTPCookieStore to UserDefaults.
    @MainActor
    public static func saveDisqusCookies(from cookieStore: WKHTTPCookieStore) async {
        let allCookies = await cookieStore.allCookies()
        let disqusCookies = allCookies.filter { $0.domain.contains(disqus) }

        guard !disqusCookies.isEmpty else { return }

        let cookieProperties = disqusCookies.compactMap { $0.properties }
        let data = try? NSKeyedArchiver.archivedData(
            withRootObject: cookieProperties,
            requiringSecureCoding: false
        )
        UserDefaults.standard.set(data, forKey: disqusCookiesKey)
    }

    /// Restores previously saved Disqus cookies into a WKHTTPCookieStore.
    @MainActor
    public static func restoreDisqusCookies(to cookieStore: WKHTTPCookieStore) async {
        guard let data = UserDefaults.standard.data(forKey: disqusCookiesKey),
              let cookieProperties = try? NSKeyedUnarchiver.unarchivedObject(
                ofClasses: [NSArray.self, NSDictionary.self, NSString.self,
                            NSNumber.self, NSDate.self, NSURL.self],
                from: data
              ) as? [[HTTPCookiePropertyKey: Any]] else {
            return
        }

        for properties in cookieProperties {
            if let cookie = HTTPCookie(properties: properties) {
                await cookieStore.setCookie(cookie)
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
            .expires: NSDate(timeIntervalSinceNow: cookieExpiration)
        ])
    }

    public static func createDarkMode(_ value: String) -> HTTPCookie? {
        return HTTPCookie(properties: [
            .domain: mmDomain,
            .path: "/",
            .name: "darkmode",
            .value: value,
            .secure: "true",
            .expires: NSDate(timeIntervalSinceNow: cookieExpiration)
        ])
    }

    public static func createFont(_ value: String) -> HTTPCookie? {
        return HTTPCookie(properties: [
            .domain: mmDomain,
            .path: "/",
            .name: "fonte",
            .value: value,
            .secure: "true",
            .expires: NSDate(timeIntervalSinceNow: cookieExpiration)
        ])
    }

    public static func createVersion(_ value: String) -> HTTPCookie? {
        return HTTPCookie(properties: [
            .domain: mmDomain,
            .path: "/",
            .name: "version",
            .value: value,
            .secure: "true",
            .expires: NSDate(timeIntervalSinceNow: cookieExpiration)
        ])
    }

    public static func createPurchased(_ value: String) -> HTTPCookie? {
        return HTTPCookie(properties: [
            .domain: mmDomain,
            .path: "/",
            .name: "patr",
            .value: value,
            .secure: "true",
            .expires: NSDate(timeIntervalSinceNow: cookieExpiration)
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
