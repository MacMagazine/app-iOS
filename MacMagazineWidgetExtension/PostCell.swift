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
    
    let post: PostData
    
    var titleFont: Font { widgetFamily == .systemSmall ? .caption : .subheadline }
    
    var coverImage: some View {
        let image: Image
        
        if redactionReasons == .placeholder {
            image = Image("widgetPlaceholder")
        } else {
            if let imageData = post.image {
                image = Image(uiImage: UIImage(data: imageData)!)
            } else {
                image = Image("widgetPlaceholder")
            }
        }
        
        return image.resizable()
            .scaledToFill()
            .unredacted()
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
                    .unredacted()
            }
            .shadow(color: Color.black.opacity(0.2), radius: 1)
            .padding([.top, .trailing])
            
            Spacer()
            
            VStack {
                HStack {
                    Text(post.title)
                        .font(titleFont)
                        .bold()
                        .multilineTextAlignment(.leading)
                    Spacer(minLength: 0)
                }
            }
            .shadow(color: .black, radius: 5)
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.01), Color.black]), startPoint: .top, endPoint: .bottom))
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(coverImage)
        .background(Color.white)
    }
}

struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        PostCell(post: .placeholder)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .redacted(reason: .placeholder)
    }
}
