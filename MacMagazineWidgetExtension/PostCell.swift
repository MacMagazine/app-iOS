//
//  PostCell.swift
//  MacMagazineWidgetExtensionExtension
//
//  Created by Ailton Vieira Pinto Filho on 16/01/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import Kingfisher
import SwiftUI
import WidgetKit

struct PostCell: View {
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.redactionReasons) var redactionReasons
    @Environment(\.accessibilityEnabled) var accessibilityEnabled

    let post: PostData

    var image: KFImage {
        if redactionReasons == .placeholder {
            return KFImage(URL(string: ""))
                .placeholder { Image("image_logo_feature") }
        } else {
            return KFImage(URL(string: post.thumbnail ?? ""))
                .placeholder { Image("image_logo_feature") }
        }
    }

    @ViewBuilder
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            coverStyle
                .widgetURL(post.url)
        default:
            Link(destination: post.url) {
                coverStyle
            }
        }
    }

    var contentView: some View {
        VStack(spacing: 2) {
            if let title = post.title {
                HStack {
                    Text(title)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                    Spacer(minLength: 0)
                }
            }
        }
    }

    var coverStyle: some View {
        VStack {
            Spacer(minLength: 0)
            contentView.shadow(color: .black, radius: 5)
            .padding()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.01), Color.black]), startPoint: .top, endPoint: .bottom))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(image.resizable().scaledToFill())
        .background(Color.white)
        .clipped()
        .colorScheme(.dark)
    }
}

struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(spacing: 1) {
                PostCell(post: .placeholder)
                PostCell(post: .placeholder)
            }
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .environment(\.sizeCategory, .extraExtraLarge)
            VStack(spacing: 1) {
                PostCell(post: .placeholder)
                PostCell(post: .placeholder)
                PostCell(post: .placeholder)
            }
            .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
        .environment(\.sizeCategory, .extraLarge)
    }
}
