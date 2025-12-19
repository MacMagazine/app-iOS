import Foundation
@testable import SettingsLibrary
import Testing

@Suite("Subscription Tests")
struct SubscriptionTests {

    // MARK: - isValidSubscription Tests

    @Test("Should be valid when expiration date is in the future")
    func validWhenFutureDate() {
        // Given
        let futureDate = Date().addingTimeInterval(86400) // 1 day from now
        let subscription = Subscription(isPatrao: false, expirationDate: futureDate)

        // When/Then
        #expect(subscription.isValidSubscription, "Subscription should be valid with future expiration date")
    }

    @Test("Should be invalid when expiration date is in the past")
    func invalidWhenPastDate() {
        // Given
        let pastDate = Date().addingTimeInterval(-86400) // 1 day ago
        let subscription = Subscription(isPatrao: false, expirationDate: pastDate)

        // When/Then
        #expect(!subscription.isValidSubscription, "Subscription should be invalid with past expiration date")
    }

    @Test("Should be invalid when expiration date is exactly now")
    func invalidAtExactExpirationTime() {
        // Given
        let now = Date()
        let subscription = Subscription(isPatrao: false, expirationDate: now)

        // When/Then
        // Date() > Date() is false, so not valid at exact expiration
        #expect(!subscription.isValidSubscription, "Subscription should be invalid at exact expiration time")
    }

    @Test("Should be valid 1 second before expiration")
    func validOneSecondBeforeExpiration() {
        // Given
        let almostExpired = Date().addingTimeInterval(1) // 1 second from now
        let subscription = Subscription(isPatrao: false, expirationDate: almostExpired)

        // When/Then
        #expect(subscription.isValidSubscription, "Subscription should be valid 1 second before expiration")
    }

    @Test("Should be invalid 1 second after expiration")
    func invalidOneSecondAfterExpiration() {
        // Given
        let justExpired = Date().addingTimeInterval(-1) // 1 second ago
        let subscription = Subscription(isPatrao: false, expirationDate: justExpired)

        // When/Then
        #expect(!subscription.isValidSubscription, "Subscription should be invalid 1 second after expiration")
    }

    @Test("Should be valid with expiration date far in the future")
    func validWithDistantFuture() {
        // Given
        let distantFuture = Date().addingTimeInterval(365 * 86400) // 1 year from now
        let subscription = Subscription(isPatrao: false, expirationDate: distantFuture)

        // When/Then
        #expect(subscription.isValidSubscription, "Subscription should be valid with distant future date")
    }

    @Test("Should be invalid with expiration date far in the past")
    func invalidWithDistantPast() {
        // Given
        let distantPast = Date().addingTimeInterval(-365 * 86400) // 1 year ago
        let subscription = Subscription(isPatrao: false, expirationDate: distantPast)

        // When/Then
        #expect(!subscription.isValidSubscription, "Subscription should be invalid with distant past date")
    }

    // MARK: - removeAds Tests

    @Test("Should remove ads when isPatrao is true, regardless of expiration")
    func removeAdsWhenPatraoTrue() {
        // Given
        let pastDate = Date().addingTimeInterval(-86400) // Expired
        let subscription = Subscription(isPatrao: true, expirationDate: pastDate)

        // When/Then
        #expect(subscription.removeAds, "Should remove ads when isPatrao is true, even with expired subscription")
    }

    @Test("Should remove ads when subscription is valid, regardless of isPatrao")
    func removeAdsWhenValidSubscription() {
        // Given
        let futureDate = Date().addingTimeInterval(86400) // Valid
        let subscription = Subscription(isPatrao: false, expirationDate: futureDate)

        // When/Then
        #expect(subscription.removeAds, "Should remove ads when subscription is valid, even if not Patrao")
    }

    @Test("Should remove ads when both isPatrao and valid subscription")
    func removeAdsWhenBothTrue() {
        // Given
        let futureDate = Date().addingTimeInterval(86400)
        let subscription = Subscription(isPatrao: true, expirationDate: futureDate)

        // When/Then
        #expect(subscription.removeAds, "Should remove ads when both isPatrao and subscription are valid")
    }

    @Test("Should not remove ads when neither isPatrao nor valid subscription")
    func noRemoveAdsWhenBothFalse() {
        // Given
        let pastDate = Date().addingTimeInterval(-86400) // Expired
        let subscription = Subscription(isPatrao: false, expirationDate: pastDate)

        // When/Then
        #expect(!subscription.removeAds, "Should not remove ads when neither isPatrao nor valid subscription")
    }

    @Test("Should remove ads with isPatrao true and expired subscription")
    func removeAdsPatraoWithExpired() {
        // Given
        let pastDate = Date().addingTimeInterval(-365 * 86400) // Long expired
        let subscription = Subscription(isPatrao: true, expirationDate: pastDate)

        // When/Then
        #expect(subscription.removeAds, "isPatrao should override expired subscription for ad removal")
    }

    @Test("Should remove ads with valid subscription and isPatrao false")
    func removeAdsValidWithoutPatrao() {
        // Given
        let futureDate = Date().addingTimeInterval(30 * 86400) // 30 days
        let subscription = Subscription(isPatrao: false, expirationDate: futureDate)

        // When/Then
        #expect(subscription.removeAds, "Valid subscription should enable ad removal without Patrao")
    }

    // MARK: - Codable Tests

    @Test("Should encode and decode correctly")
    func codableConformance() throws {
        // Given
        let originalDate = Date()
        let original = Subscription(isPatrao: true, expirationDate: originalDate)

        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Subscription.self, from: data)

        // Then
        #expect(decoded.isPatrao == original.isPatrao)
        // Dates might have slight precision differences, check within 1 second
        let timeDifference = abs(decoded.expirationDate.timeIntervalSince(original.expirationDate))
        #expect(timeDifference < 1.0, "Decoded date should match original within 1 second")
    }

    // MARK: - Edge Cases

    @Test("Should handle maximum date value")
    func handleMaximumDate() {
        // Given
        let maxDate = Date.distantFuture
        let subscription = Subscription(isPatrao: false, expirationDate: maxDate)

        // When/Then
        #expect(subscription.isValidSubscription, "Should handle distant future date")
        #expect(subscription.removeAds, "Should remove ads with distant future date")
    }

    @Test("Should handle minimum date value")
    func handleMinimumDate() {
        // Given
        let minDate = Date.distantPast
        let subscription = Subscription(isPatrao: false, expirationDate: minDate)

        // When/Then
        #expect(!subscription.isValidSubscription, "Should handle distant past date")
        #expect(!subscription.removeAds, "Should not remove ads with distant past date")
    }

    @Test("Should calculate validity correctly for typical monthly subscription")
    func typicalMonthlySubscription() {
        // Given - 30 days from now (typical subscription)
        let monthFromNow = Date().addingTimeInterval(30 * 86400)
        let subscription = Subscription(isPatrao: false, expirationDate: monthFromNow)

        // When/Then
        #expect(subscription.isValidSubscription, "Monthly subscription should be valid")
        #expect(subscription.removeAds, "Monthly subscription should remove ads")
    }

    @Test("Should calculate validity correctly for typical yearly subscription")
    func typicalYearlySubscription() {
        // Given - 365 days from now (typical yearly subscription)
        let yearFromNow = Date().addingTimeInterval(365 * 86400)
        let subscription = Subscription(isPatrao: false, expirationDate: yearFromNow)

        // When/Then
        #expect(subscription.isValidSubscription, "Yearly subscription should be valid")
        #expect(subscription.removeAds, "Yearly subscription should remove ads")
    }
}
