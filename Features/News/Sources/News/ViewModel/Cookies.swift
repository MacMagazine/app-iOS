import CommonLibrary
import Settings
import UIKit

struct Cookies {

    static func get(_ domain: String? = nil) -> [HTTPCookie]? {
        let cookies = HTTPCookieStorage.shared.cookies

        guard let domain = domain else {
            return cookies
        }

        return cookies?.filter {
            return $0.domain.contains(domain)
        }
    }

    static func clean() {
        for cookie in Self.get() ?? [] {
            if !cookie.domain.contains(APIParams.disqus) &&
                !cookie.domain.contains(APIParams.mainDomain) {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }

    static func darkMode(_ mode: ColorScheme) -> HTTPCookie? {
        var darkMode: String {
            switch mode {
            case .dark: return "true"
            case .light: return "false"
            case .system:
                if (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.last?.rootViewController?.traitCollection.userInterfaceStyle == .dark {
                    return "true"
                } else {
                    return "false"
                }
            }
        }

        return HTTPCookie(properties: [
            .domain: APIParams.mainDomain,
            .path: "/",
            .name: "darkmode",
            .value: darkMode,
            .secure: "true",
            .expires: NSDate(timeIntervalSinceNow: 60)
        ])
    }

    static var font: HTTPCookie? {
        var fontSizeUserAgent: String {
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

        return HTTPCookie(properties: [
            .domain: APIParams.mainDomain,
            .path: "/",
            .name: "fonte",
            .value: fontSizeUserAgent,
            .secure: "true",
            .expires: NSDate(timeIntervalSinceNow: 60)
        ])
    }

    static func version(_ value: String) -> HTTPCookie? {
        return HTTPCookie(properties: [
            .domain: APIParams.mainDomain,
            .path: "/",
            .name: "version",
            .value: value,
            .secure: "true",
            .expires: NSDate(timeIntervalSinceNow: 60)
        ])
    }

    static func purchased(_ flag: Bool) -> HTTPCookie? {
        return HTTPCookie(properties: [
            .domain: APIParams.mainDomain,
            .path: "/",
            .name: "patr",
            .value: flag ? "true" : "false",
            .secure: "true",
            .expires: NSDate(timeIntervalSinceNow: 60)
        ])
    }
}

extension String {
    func llamaCase() -> String {
        return "\(self.first?.lowercased() ?? "")\(self.dropFirst())"
    }
}
