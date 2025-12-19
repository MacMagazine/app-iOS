import Foundation
@testable import MacMagazineUILibrary
import Testing

@Suite("Cookies Tests")
struct CookiesTests {

    // MARK: - llamaCase String Extension Tests

    @Test("Should lowercase first character of PascalCase string")
    func llamaCasePascalCase() {
        // Given
        let input = "PascalCase"

        // When
        let output = input.llamaCase()

        // Then
        #expect(output == "pascalCase", "Should convert PascalCase to pascalCase")
    }

    @Test("Should keep camelCase string unchanged")
    func llamaCaseCamelCase() {
        // Given
        let input = "camelCase"

        // When
        let output = input.llamaCase()

        // Then
        #expect(output == "camelCase", "Should keep camelCase unchanged")
    }

    @Test("Should handle single uppercase character")
    func llamaCaseSingleUppercase() {
        // Given
        let input = "A"

        // When
        let output = input.llamaCase()

        // Then
        #expect(output == "a", "Should lowercase single character")
    }

    @Test("Should handle single lowercase character")
    func llamaCaseSingleLowercase() {
        // Given
        let input = "a"

        // When
        let output = input.llamaCase()

        // Then
        #expect(output == "a", "Should keep single lowercase character")
    }

    @Test("Should handle empty string")
    func llamaCaseEmpty() {
        // Given
        let input = ""

        // When
        let output = input.llamaCase()

        // Then
        #expect(output.isEmpty, "Should handle empty string")
    }

    @Test("Should handle all uppercase string")
    func llamaCaseAllUppercase() {
        // Given
        let input = "UPPERCASE"

        // When
        let output = input.llamaCase()

        // Then
        #expect(output == "uPPERCASE", "Should only lowercase first character")
    }

    @Test("Should handle string with numbers")
    func llamaCaseWithNumbers() {
        // Given
        let input = "Test123String"

        // When
        let output = input.llamaCase()

        // Then
        #expect(output == "test123String", "Should handle strings with numbers")
    }

    @Test("Should handle string with special characters")
    func llamaCaseWithSpecialChars() {
        // Given
        let input = "Test-String_Value"

        // When
        let output = input.llamaCase()

        // Then
        #expect(output == "test-String_Value", "Should handle special characters")
    }

    @Test("Should handle string starting with lowercase already")
    func llamaCaseLowercaseStart() {
        // Given
        let input = "lowercase"

        // When
        let output = input.llamaCase()

        // Then
        #expect(output == "lowercase", "Should remain unchanged")
    }

    @Test("Should handle typical iOS size category transformation")
    func llamaCaseTypicalSize() {
        // Given
        let input = "ExtraLarge"

        // When
        let output = input.llamaCase()

        // Then
        #expect(output == "extraLarge", "Should convert to camelCase")
    }

    // MARK: - Cookie Creation Tests

    @Test("Should create dark mode cookie with true value")
    func createDarkModeCookieTrue() {
        // Given/When
        let cookie = Cookies.createDarkMode("true")

        // Then
        #expect(cookie != nil, "Should create cookie")
        #expect(cookie?.name == "darkmode", "Should have correct name")
        #expect(cookie?.value == "true", "Should have correct value")
        #expect(cookie?.domain == "macmagazine.com.br", "Should have correct domain")
        #expect(cookie?.path == "/", "Should have correct path")
        #expect(cookie?.isSecure == true, "Should be secure")
    }

    @Test("Should create dark mode cookie with false value")
    func createDarkModeCookieFalse() {
        // Given/When
        let cookie = Cookies.createDarkMode("false")

        // Then
        #expect(cookie != nil, "Should create cookie")
        #expect(cookie?.value == "false", "Should have false value")
    }

    @Test("Should create color schema cookie for dark")
    func createColorSchemaDark() {
        // Given/When
        let cookie = Cookies.createColorSchema("dark")

        // Then
        #expect(cookie != nil, "Should create cookie")
        #expect(cookie?.name == "_color_schema", "Should have correct name")
        #expect(cookie?.value == "dark", "Should have dark value")
    }

    @Test("Should create color schema cookie for light")
    func createColorSchemaLight() {
        // Given/When
        let cookie = Cookies.createColorSchema("light")

        // Then
        #expect(cookie != nil, "Should create cookie")
        #expect(cookie?.value == "light", "Should have light value")
    }

    @Test("Should create font cookie with custom value")
    func createFontCookie() {
        // Given/When
        let cookie = Cookies.createFont("medium")

        // Then
        #expect(cookie != nil, "Should create cookie")
        #expect(cookie?.name == "fonte", "Should have correct name")
        #expect(cookie?.value == "medium", "Should have correct value")
    }

    @Test("Should create version cookie")
    func createVersionCookie() {
        // Given/When
        let cookie = Cookies.createVersion("5.0")

        // Then
        #expect(cookie != nil, "Should create cookie")
        #expect(cookie?.name == "version", "Should have correct name")
        #expect(cookie?.value == "5.0", "Should have correct value")
    }

    @Test("Should create purchased cookie")
    func createPurchasedCookie() {
        // Given/When
        let cookie = Cookies.createPurchased("true")

        // Then
        #expect(cookie != nil, "Should create cookie")
        #expect(cookie?.name == "patr", "Should have correct name")
        #expect(cookie?.value == "true", "Should have correct value")
    }

    // MARK: - makeCookies Tests

    @Test("Should create cookies for dark mode enabled")
    @MainActor
    func makeCookiesDarkMode() {
        // Given/When
        let cookies = Cookies.makeCookies(darkMode: true, font: nil, removeAds: false)

        // Then
        #expect(!cookies.isEmpty, "Should create cookies")

        let darkModeCookie = cookies.first { $0.name == "darkmode" }
        #expect(darkModeCookie?.value == "true", "Should have dark mode true")

        let colorSchemaCookie = cookies.first { $0.name == "_color_schema" }
        #expect(colorSchemaCookie?.value == "dark", "Should have dark color schema")
    }

    @Test("Should create cookies for light mode")
    @MainActor
    func makeCookiesLightMode() {
        // Given/When
        let cookies = Cookies.makeCookies(darkMode: false, font: nil, removeAds: false)

        // Then
        #expect(!cookies.isEmpty, "Should create cookies")

        let darkModeCookie = cookies.first { $0.name == "darkmode" }
        #expect(darkModeCookie?.value == "false", "Should have dark mode false")

        let colorSchemaCookie = cookies.first { $0.name == "_color_schema" }
        #expect(colorSchemaCookie?.value == "light", "Should have light color schema")
    }

    @Test("Should create cookies with custom font")
    @MainActor
    func makeCookiesCustomFont() {
        // Given/When
        let cookies = Cookies.makeCookies(darkMode: true, font: "extraLarge", removeAds: false)

        // Then
        let fontCookie = cookies.first { $0.name == "fonte" }
        #expect(fontCookie?.value == "extraLarge", "Should have custom font")
    }

    @Test("Should create cookies with removeAds enabled")
    @MainActor
    func makeCookiesRemoveAds() {
        // Given/When
        let cookies = Cookies.makeCookies(darkMode: true, font: nil, removeAds: true)

        // Then
        let purchasedCookie = cookies.first { $0.name == "patr" }
        #expect(purchasedCookie?.value == "true", "Should have removeAds true")
    }

    @Test("Should create cookies with removeAds disabled")
    @MainActor
    func makeCookiesNoRemoveAds() {
        // Given/When
        let cookies = Cookies.makeCookies(darkMode: true, font: nil, removeAds: false)

        // Then
        let purchasedCookie = cookies.first { $0.name == "patr" }
        #expect(purchasedCookie?.value == "false", "Should have removeAds false")
    }

    @Test("Should create all cookies with all parameters")
    @MainActor
    func makeCookiesAllParameters() {
        // Given/When
        let cookies = Cookies.makeCookies(darkMode: true, font: "large", removeAds: true)

        // Then
        #expect(cookies.count >= 4, "Should create at least 4 cookies")

        #expect(cookies.contains { $0.name == "darkmode" }, "Should have dark mode cookie")
        #expect(cookies.contains { $0.name == "_color_schema" }, "Should have color schema cookie")
        #expect(cookies.contains { $0.name == "fonte" }, "Should have font cookie")
        #expect(cookies.contains { $0.name == "patr" }, "Should have purchased cookie")
    }

    @Test("Should handle nil removeAds parameter")
    @MainActor
    func makeCookiesNilRemoveAds() {
        // Given/When
        let cookies = Cookies.makeCookies(darkMode: true, font: nil, removeAds: nil)

        // Then
        let purchasedCookie = cookies.first { $0.name == "patr" }
        #expect(purchasedCookie?.value == "false", "Should treat nil removeAds as false")
    }

    // MARK: - Cookie Domain and Security Tests

    @Test("All cookies should have correct domain")
    @MainActor
    func allCookiesCorrectDomain() {
        // Given/When
        let cookies = Cookies.makeCookies(darkMode: true, font: "large", removeAds: true)

        // Then
        for cookie in cookies {
            #expect(cookie.domain == "macmagazine.com.br", "All cookies should have MM domain")
        }
    }

    @Test("All cookies should be secure")
    @MainActor
    func allCookiesSecure() {
        // Given/When
        let cookies = Cookies.makeCookies(darkMode: true, font: "large", removeAds: true)

        // Then
        for cookie in cookies {
            #expect(cookie.isSecure == true, "All cookies should be secure")
        }
    }

    @Test("All cookies should have root path")
    @MainActor
    func allCookiesRootPath() {
        // Given/When
        let cookies = Cookies.makeCookies(darkMode: true, font: "large", removeAds: true)

        // Then
        for cookie in cookies {
            #expect(cookie.path == "/", "All cookies should have root path")
        }
    }

    @Test("All cookies should have expiration date")
    @MainActor
    func allCookiesHaveExpiration() {
        // Given/When
        let cookies = Cookies.makeCookies(darkMode: true, font: "large", removeAds: true)

        // Then
        for cookie in cookies {
            #expect(cookie.expiresDate != nil, "All cookies should have expiration date")
        }
    }
}
