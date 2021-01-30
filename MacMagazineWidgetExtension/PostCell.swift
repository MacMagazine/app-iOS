//
//  PostCell.swift
//  MacMagazineWidgetExtensionExtension
//
//  Created by Ailton Vieira Pinto Filho on 16/01/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import SwiftUI
import WidgetKit

struct PostCell: View {
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.redactionReasons) var redactionReasons
    @Environment(\.accessibilityEnabled) var accessibilityEnabled

    let post: PostData
    let style: Style

    enum Style { case cover, row }

    var image: Image {
        if redactionReasons == .placeholder {
            return Image("widgetPlaceholder")
        } else {
            if let imageData = post.imageData,
               let uiImage = UIImage(data: imageData) {
                return Image(uiImage: uiImage)
            } else {
                return Image("widgetPlaceholder")
            }
        }
    }

    @ViewBuilder
    var cell: some View {
        switch style {
        case .cover:
            coverStyle
        case .row:
            rowStyle
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

    var body: some View {
        Group {
            if let url = post.url {
                Link(destination: url) {
                    cell
                }
            } else {
                cell
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

    var rowStyle: some View {
        GeometryReader { geo in
            HStack(spacing: 8) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 0.18 * geo.size.width, height: geo.size.height)
                    .clipped()
                    .cornerRadius(8)
                contentView
            }
        }
    }
}

struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                PostCell(post: .placeholder, style: .cover)
                PostCell(post: .placeholder, style: .cover)
            }
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .environment(\.sizeCategory, .extraExtraLarge)
            VStack {
                PostCell(post: .placeholder, style: .cover)
                PostCell(post: .placeholder, style: .cover)
                PostCell(post: .placeholder, style: .cover)
            }
            .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
        .environment(\.sizeCategory, .extraLarge)
    }
}
