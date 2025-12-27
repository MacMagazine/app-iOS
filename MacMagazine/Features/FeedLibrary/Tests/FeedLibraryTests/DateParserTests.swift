@testable import FeedLibrary
import Foundation
import Testing

@Suite("DateParser Tests")
struct DateParserTests {

    let sut = DateParser()

    @Test("Should parse valid RSS date format correctly")
    func parseValidRSSDate() {
        let dateString = "Mon, 15 Jan 2024 14:30:00 +0000"

        let result = sut.parse(dateString)

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: result)

        #expect(components.year == 2024)
        #expect(components.month == 1)
        #expect(components.day == 15)
        #expect(components.hour == 14)
        #expect(components.minute == 30)
        #expect(components.second == 0)
    }

    @Test("Should parse date with different day names")
    func parseDifferentDays() {
        let dates = [
            ("Mon, 01 Jan 2024 00:00:00 +0000", 1),
            ("Tue, 02 Jan 2024 00:00:00 +0000", 2),
            ("Wed, 03 Jan 2024 00:00:00 +0000", 3),
            ("Thu, 04 Jan 2024 00:00:00 +0000", 4),
            ("Fri, 05 Jan 2024 00:00:00 +0000", 5),
            ("Sat, 06 Jan 2024 00:00:00 +0000", 6),
            ("Sun, 07 Jan 2024 00:00:00 +0000", 7)
        ]

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current

        for (dateString, expectedDay) in dates {
            let result = sut.parse(dateString)
            let day = calendar.component(.day, from: result)
            #expect(day == expectedDay, "Failed for \(dateString)")
        }
    }

    @Test("Should parse date with different months")
    func parseDifferentMonths() {
        let months = [
            ("Mon, 15 Jan 2024 12:00:00 +0000", 1),
            ("Thu, 15 Feb 2024 12:00:00 +0000", 2),
            ("Fri, 15 Mar 2024 12:00:00 +0000", 3),
            ("Mon, 15 Apr 2024 12:00:00 +0000", 4),
            ("Wed, 15 May 2024 12:00:00 +0000", 5),
            ("Sat, 15 Jun 2024 12:00:00 +0000", 6),
            ("Mon, 15 Jul 2024 12:00:00 +0000", 7),
            ("Thu, 15 Aug 2024 12:00:00 +0000", 8),
            ("Sun, 15 Sep 2024 12:00:00 +0000", 9),
            ("Tue, 15 Oct 2024 12:00:00 +0000", 10),
            ("Fri, 15 Nov 2024 12:00:00 +0000", 11),
            ("Sun, 15 Dec 2024 12:00:00 +0000", 12)
        ]

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current

        for (dateString, expectedMonth) in months {
            let result = sut.parse(dateString)
            let month = calendar.component(.month, from: result)
            #expect(month == expectedMonth, "Failed for \(dateString)")
        }
    }

    @Test("Should parse midnight time correctly")
    func parseMidnight() {
        let dateString = "Mon, 01 Jan 2024 00:00:00 +0000"

        let result = sut.parse(dateString)

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        let components = calendar.dateComponents([.hour, .minute, .second], from: result)

        #expect(components.hour == 0)
        #expect(components.minute == 0)
        #expect(components.second == 0)
    }

    @Test("Should parse end of day time correctly")
    func parseEndOfDay() {
        let dateString = "Mon, 01 Jan 2024 23:59:59 +0000"

        let result = sut.parse(dateString)

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        let components = calendar.dateComponents([.hour, .minute, .second], from: result)

        #expect(components.hour == 23)
        #expect(components.minute == 59)
        #expect(components.second == 59)
    }

    @Test("Should parse single digit day correctly")
    func parseSingleDigitDay() {
        let dateString = "Mon, 01 Jan 2024 12:00:00 +0000"

        let result = sut.parse(dateString)

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        let day = calendar.component(.day, from: result)

        #expect(day == 1)
    }

    @Test("Should parse double digit day correctly")
    func parseDoubleDigitDay() {
        let dateString = "Wed, 31 Jan 2024 12:00:00 +0000"

        let result = sut.parse(dateString)

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        let day = calendar.component(.day, from: result)

        #expect(day == 31)
    }

    @Test("Should return current date for invalid format")
    func returnCurrentDateForInvalidFormat() {
        let invalidString = "Not a valid date"
        let beforeParse = Date()

        let result = sut.parse(invalidString)

        let afterParse = Date()

        #expect(result >= beforeParse)
        #expect(result <= afterParse)
    }

    @Test("Should return current date for empty string")
    func returnCurrentDateForEmptyString() {
        let beforeParse = Date()

        let result = sut.parse("")

        let afterParse = Date()

        #expect(result >= beforeParse)
        #expect(result <= afterParse)
    }

    @Test("Should return current date for partial date string")
    func returnCurrentDateForPartialString() {
        let beforeParse = Date()

        let result = sut.parse("Mon, 15 Jan")

        let afterParse = Date()

        #expect(result >= beforeParse)
        #expect(result <= afterParse)
    }

    @Test("Should parse date from different years")
    func parseDifferentYears() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current

        let years = [2020, 2021, 2022, 2023, 2024, 2025]

        for year in years {
            let dateString = "Mon, 01 Jan \(year) 12:00:00 +0000"
            let result = sut.parse(dateString)
            let parsedYear = calendar.component(.year, from: result)
            #expect(parsedYear == year, "Failed for year \(year)")
        }
    }

    @Test("Should handle leap year date")
    func parseLeapYearDate() {
        let dateString = "Thu, 29 Feb 2024 12:00:00 +0000"

        let result = sut.parse(dateString)

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        let components = calendar.dateComponents([.year, .month, .day], from: result)

        #expect(components.year == 2024)
        #expect(components.month == 2)
        #expect(components.day == 29)
    }

    @Test("Should be consistent across multiple parses of same date")
    func consistentParsing() {
        let dateString = "Mon, 15 Jan 2024 14:30:00 +0000"

        let result1 = sut.parse(dateString)
        let result2 = sut.parse(dateString)
        let result3 = sut.parse(dateString)

        #expect(result1 == result2)
        #expect(result2 == result3)
    }

    @Test("Should parse dates that are far in the past")
    func parseFarPastDate() {
        let dateString = "Mon, 01 Jan 2000 00:00:00 +0000"

        let result = sut.parse(dateString)

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        let year = calendar.component(.year, from: result)

        #expect(year == 2000)
    }

    @Test("Should parse dates that are far in the future")
    func parseFarFutureDate() {
        let dateString = "Thu, 01 Jan 2030 00:00:00 +0000"

        let result = sut.parse(dateString)

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        let year = calendar.component(.year, from: result)

        #expect(year == 2030)
    }
}
