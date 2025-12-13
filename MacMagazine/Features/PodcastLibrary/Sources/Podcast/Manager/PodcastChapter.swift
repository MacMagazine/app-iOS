import AVFoundation
import Foundation
import SwiftUI

struct PodcastChapter: Hashable {
    let id = UUID()
    let title: String
    let start: CMTime
    let end: CMTime
    let duration: CMTime

    var startString: String {
        timeString(using: start.seconds)
    }

    var durationString: String {
        timeString(using: duration.seconds)
    }

    func backgroundColor(at position: Double) -> Color {
        if position >= start.seconds && position < end.seconds {
            .gray.opacity(0.7)
        } else {
            .clear
        }
    }

    private func timeString(using seconds: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour]
        formatter.zeroFormattingBehavior = .pad
        let output = formatter.string(from: TimeInterval(seconds))
        if seconds < 3600,
           let output,
            let range = output.range(of: ":") {
            return String(output[range.upperBound...])
        } else {
            return output ?? "\(seconds)"
        }
    }
}
