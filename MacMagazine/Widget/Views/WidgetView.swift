import FeedLibrary
import Kingfisher
import SwiftUI
import UIComponentsLibrary
import UtilityLibrary
import WidgetKit

struct WidgetView: View {
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.redactionReasons) var redactionReasons
    @Environment(\.widgetRenderingMode) var renderingMode

    let post: WidgetData

    @ViewBuilder
    var body: some View {
        switch widgetFamily {
        case .systemSmall: smallWidget
        case .accessoryInline: accessoryInlineWidget
        case .accessoryCircular: accessoryCircularWidget
        case .accessoryRectangular: accessoryRectangularWidget
        default: Link(destination: post.url) { content(image: image) }
        }
    }
}

private extension WidgetView {
    var smallWidget: some View {
        content(image: nil).widgetURL(post.url)
    }

    var accessoryInlineWidget: some View {
        Text("MM \(post.title)").widgetURL(post.url)
    }

    var accessoryCircularWidget: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
            VStack(spacing: 0) {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                Text("\(0)").widgetURL(post.url) // Helper().badgeCount
            }
        }
        .containerBackground(Color.clear, for: .widget)
    }

    var accessoryRectangularWidget: some View {
        HStack(spacing: 5) {
            VStack {
                Image("logo_white")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                Spacer(minLength: 0)
            }
            VStack(spacing: 0) {
                Text(post.title).widgetURL(post.url)
                Spacer(minLength: 0)
            }
        }
        .containerBackground(Color.clear, for: .widget)
    }
}

private extension WidgetView {
    func content(image: KFImage?) -> some View {
        HStack(spacing: 6) {
            VStack(spacing: 4) {
                HStack {
                    Text(post.pubDate.format(using: .dateTime))
                        .font(.caption)
                        .lineLimit(1)
                    Spacer(minLength: 0)
                }
                HStack {
                    Text(post.title)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                    Spacer(minLength: 0)
                }
            }

            if let image, renderingMode != .accented {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSize, height: imageSize)
                    .cornerRadius(8)
            }
        }
        .widgetAccentable() // This will be in the accent group in tinted mode
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .containerBackground(Color.clear, for: .widget)
        .clipped()
    }

    var image: KFImage {
        KFImage(URL(string: redactionReasons == .placeholder ? "" : post.thumbnail))
            .placeholder { Image("logo") }
    }
}

private extension WidgetView {
    var imageSize: CGFloat {
        switch widgetFamily {
        case .systemMedium: 40
        case .systemLarge: 60
        default: 0
        }
    }
}
