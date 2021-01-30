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
        HStack {
            Text(post.title ?? "")
                .font(.subheadline)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }

    var body: some View {
        if let link = post.link, let url = URL(string: link) {
            Link(destination: url) {
                cell
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
            }
        } else {
            cell
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
        }
    }

    var coverStyle: some View {
        VStack {
            HStack {
                Spacer()
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                    .unredacted()
            }
            .shadow(color: Color.black.opacity(0.4), radius: 1)
            .padding([.top, .trailing])
            Spacer(minLength: 0)
            contentView.shadow(color: .black, radius: 5)
            .padding([.horizontal, .bottom])
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.01), Color.black]), startPoint: .top, endPoint: .bottom))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(image.resizable().scaledToFill())
        .clipped()
        .colorScheme(.dark)
    }

    var rowStyle: some View {
        GeometryReader { geo in
            HStack {
                Spacer(minLength: 4)
                VStack {
                    Spacer()
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: (0.8 * geo.size.height) / (101 / 70), // to match cell on a Post
                               height: 0.8 * geo.size.height)
                        .clipped()
                        .cornerRadius(8)
                    Spacer()
                }
                VStack {
                    Spacer()
                    contentView
                    Spacer()
                }
            }
        }
    }
}

struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                PostCell(post: .placeholder, style: .row)
                PostCell(post: .placeholder, style: .row)
            }.padding()
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            .environment(\.sizeCategory, .extraExtraLarge)
            GeometryReader { geo in
                VStack {
                    PostCell(post: .placeholder, style: .cover)
                        .frame(height: 0.5 * geo.size.height)
                    VStack {
                        PostCell(post: .placeholder, style: .row)
                        PostCell(post: .placeholder, style: .row)
                    }.padding()
                }
            }
            .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
//        .redacted(reason: .placeholder)
        .environment(\.sizeCategory, .extraLarge)
    }
}
