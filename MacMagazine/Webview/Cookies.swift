//
//  Cookies.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 08/10/20.
//  Copyright © 2020 MacMagazine. All rights reserved.
//

import Foundation

struct Cookies {

    let disqus = API.APIParams.disqus
    let mm = API.APIParams.mmDomain

    func getCookies(_ domain: String? = nil) -> [HTTPCookie]? {
        let cookies = HTTPCookieStorage.shared.cookies

        guard let domain = domain else {
            return cookies
        }

        return cookies?.filter {
            return $0.domain.contains(domain)
        }
    }

    func cleanCookies() {
        for cookie in getCookies() ?? [] {
            if !cookie.domain.contains(disqus) &&
                !cookie.domain.contains(mm) {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }

    func createDarkModeCookie(_ value: String) -> HTTPCookie? {
        return HTTPCookie(properties: [
            .domain: mm,
            .path: "/",
            .name: "darkmode",
            .value: value,
            .secure: "false",
            .expires: NSDate(timeIntervalSinceNow: 3600)
        ])
    }

    func createFonteCookie(_ value: String) -> HTTPCookie? {
        return HTTPCookie(properties: [
            .domain: mm,
            .path: "/",
            .name: "fonte",
            .value: value,
            .secure: "false",
            .expires: NSDate(timeIntervalSinceNow: 3600)
        ])
    }

    func createVersionCookie(_ value: String) -> HTTPCookie? {
        return HTTPCookie(properties: [
            .domain: mm,
            .path: "/",
            .name: "version",
            .value: value,
            .secure: "false",
            .expires: NSDate(timeIntervalSinceNow: 3600)
        ])
    }

    func createPurchasedCookie(_ value: String) -> HTTPCookie? {
        return HTTPCookie(properties: [
            .domain: mm,
            .path: "/",
            .name: "patr",
            .value: value,
            .secure: "false",
            .expires: NSDate(timeIntervalSinceNow: 3600)
        ])
    }
}
