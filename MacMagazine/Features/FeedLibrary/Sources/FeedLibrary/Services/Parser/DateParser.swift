import Foundation

class DateParser {
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    func parse(_ dateString: String) -> Date {
        formatter.date(from: dateString) ?? Date()
    }
}
