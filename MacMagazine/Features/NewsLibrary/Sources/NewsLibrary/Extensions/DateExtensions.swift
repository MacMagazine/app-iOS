import Foundation

// MARK: - Date Extensions for Feed

public extension Date {

    // MARK: - Custom Format

    /// Format date with custom format string
    func formatted(as format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: self)
    }

    // MARK: - Relative Formatting

    /// Returns a human-readable relative time string
    var relativeTimeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    /// Returns a formatted date string for feed display
    var feedDisplayString: String {
        let calendar = Calendar.current
        let now = Date()

        if calendar.isDateInToday(self) {
            return "Hoje, \(formatted(date: .omitted, time: .shortened))"
        } else if calendar.isDateInYesterday(self) {
            return "Ontem, \(formatted(date: .omitted, time: .shortened))"
        } else if let daysAgo = calendar.dateComponents([.day], from: self, to: now).day, daysAgo < 7 {
            return relativeTimeString
        } else {
            return formatted(date: .abbreviated, time: .omitted)
        }
    }

    // MARK: - Time Ago String

    /// Returns a detailed time ago string
    var timeAgoString: String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year], from: self, to: now)

        if let years = components.year, years > 0 {
            return years == 1 ? "há 1 ano" : "há \(years) anos"
        }
        if let months = components.month, months > 0 {
            return months == 1 ? "há 1 mês" : "há \(months) meses"
        }
        if let weeks = components.weekOfYear, weeks > 0 {
            return weeks == 1 ? "há 1 semana" : "há \(weeks) semanas"
        }
        if let days = components.day, days > 0 {
            return days == 1 ? "há 1 dia" : "há \(days) dias"
        }
        if let hours = components.hour, hours > 0 {
            return hours == 1 ? "há 1 hora" : "há \(hours) horas"
        }
        if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "há 1 minuto" : "há \(minutes) minutos"
        }

        return "agora"
    }

    // MARK: - Accessibility String

    /// Returns a detailed accessibility-friendly date string
    var accessibilityDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: self)
    }

    /// Hoje às HH:mm / Ontem às HH:mm / dd/MM/yyyy às HH:mm
    var feedDateTimeDisplay: String {
        let calendar = Calendar.current

        if calendar.isDateInToday(self) {
            return "Hoje às \(Self.feedTimeFormatter.string(from: self))"
        }

        if calendar.isDateInYesterday(self) {
            return "Ontem às \(Self.feedTimeFormatter.string(from: self))"
        }

        return Self.feedDateTimeFormatter.string(from: self)
    }

    // MARK: - Private formatters (cache)

    private static let feedTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    private static let feedDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "dd/MM/yyyy 'às' HH:mm"
        return formatter
    }()
}

// MARK: - Preview Helper

#if DEBUG
extension Date {
    static var mockDates: [Date] {
        let now = Date()
        return [
            now,
            now.addingTimeInterval(-60 * 5),           // 5 minutes ago
            now.addingTimeInterval(-60 * 60),          // 1 hour ago
            now.addingTimeInterval(-60 * 60 * 5),      // 5 hours ago
            now.addingTimeInterval(-60 * 60 * 24),     // 1 day ago
            now.addingTimeInterval(-60 * 60 * 24 * 3), // 3 days ago
            now.addingTimeInterval(-60 * 60 * 24 * 7), // 1 week ago
            now.addingTimeInterval(-60 * 60 * 24 * 30) // 1 month ago
        ]
    }
}
#endif
