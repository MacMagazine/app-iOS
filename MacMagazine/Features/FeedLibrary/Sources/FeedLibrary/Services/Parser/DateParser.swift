import Foundation

class DateParser {    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss +0000"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    func parse(_ dateString: String) -> Date {
        formatter.date(from: dateString) ?? Date()
    }
}
