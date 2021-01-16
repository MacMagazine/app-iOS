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
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                HStack {
                    Text("Titulo do Post")
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                    Spacer(minLength: 0)
                }
                HStack {
                    (Text("POR ") + Text("LUIZ GUSTAVO RIBEIRO").bold())
                        .lineLimit(2)
                    Spacer(minLength: 0)
                }.font(.system(size: 8)).padding(.top, 3)
            }
            .shadow(color: .black, radius: 5)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.01), Color.black]), startPoint: .top, endPoint: .bottom))
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(
            Image("CoverSample")
                .resizable()
                .scaledToFill()
        )
        .background(Color.white)
    }
}

struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        PostCell()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
