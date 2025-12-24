import Foundation

public extension Date {
    func toTimeAgoDisplay(showTime: Bool) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self, to: Date())

        guard let days = components.day, days <= 7 else {
            return self.format(using: showTime ? .dateTime : .dateOnly)
        }

        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
