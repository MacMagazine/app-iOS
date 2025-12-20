import FeedLibrary
import SwiftUI
import UIComponentsLibrary
import UIKit
import UtilityLibrary
import WidgetKit

struct WidgetElementView: View {
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.redactionReasons) var redactionReasons
    @Environment(\.widgetRenderingMode) var renderingMode

    let post: WidgetData

    @ViewBuilder
    var body: some View {
        switch widgetFamily {
        case .systemSmall: smallWidget.widgetURL(post.url)
        case .accessoryInline: accessoryInlineWidget
        case .accessoryCircular: accessoryCircularWidget
        case .accessoryRectangular: accessoryRectangularWidget
        default: Link(destination: post.url) { content }
        }
    }
}

private extension WidgetElementView {
    var accessoryInlineWidget: some View {
        Text("MM \(post.title)").widgetURL(post.url)
    }

    var accessoryCircularWidget: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
            VStack(spacing: 0) {
                Image("logo_white")
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

private extension WidgetElementView {
    var dateAndTitle: some View {
        VStack(spacing: 4) {
            if widgetFamily == .systemLarge || widgetFamily == .systemSmall {
                HStack {
                    Text(post.pubDate.format(using: .dateTime))
                        .font(.caption2)
                        .lineLimit(1)
                    Spacer(minLength: 0)
                }
            }
            HStack {
                Text(post.title)
                    .font(.callout)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                Spacer(minLength: 0)
            }
        }
    }

    var image: Image {
        guard let imageData = post.imageData,
              let uiImage = UIImage(data: imageData) else {
            return Image("logo_white")
        }
        return Image(uiImage: uiImage)
    }

    @ViewBuilder
    private var imageForRenderingMode: some View {
        if renderingMode == .accented {
            Color.clear
        } else {
            image.resizable().scaledToFill()
        }
    }

    var smallWidget: some View {
        VStack(alignment: .leading, spacing: 6) {
            Spacer()

            HStack {
                Image(renderingMode == .accented ? "logo_white" : "logo_color")
                    .resizable()
                    .widgetAccentedRenderingMode(.fullColor)
                    .scaledToFit()
                Spacer()
            }
            .frame(height: 20)
            .padding(.bottom, 6)

            Text(post.title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .lineLimit(3)

            Text(post.pubDate.format(using: .dateTime))
                .font(.caption2)
                .foregroundStyle(.primary)
                .lineLimit(1)
        }
        .padding(.horizontal, 10)
        .padding(.bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .smallWidgetStyle(image: image)
    }

    var content: some View {
        HStack(spacing: 6) {
            dateAndTitle
            if renderingMode != .accented {
                imageForRenderingMode
                    .frame(width: imageSize, height: imageSize)
                    .cornerRadius(8)
            }
        }
        .widgetAccentable() // This will be in the accent group in tinted mode
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .containerBackground(Color.clear, for: .widget)
        .clipped()
    }
}

private extension WidgetElementView {
    var imageSize: CGFloat {
        switch widgetFamily {
        case .systemMedium: 40
        case .systemLarge: 60
        default: 0
        }
    }
}
