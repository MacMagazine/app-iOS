import CommonLibrary
import News
import SwiftUI
import YouTubeLibrary

struct FavouritesView: View {
    struct Options: Hashable {
        let title: String
        let selection: Int
    }
    
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var viewModel: MainViewModel
    
    @State var selection = 0
    
    var body: some View {
        VStack {
            header
            menu
            tabs
        }
        .environment(\.managedObjectContext, viewModel.newsViewModel.mainContext)
    }
}

extension FavouritesView {
    @ViewBuilder
    private var header: some View {
        HStack {
            Text("Favoritos")
                .font(.largeTitle)
                .foregroundColor(theme.text.terciary.color)
            
            Spacer()
        }
        .padding([.top, .leading])
    }
}

extension FavouritesView {
    @ViewBuilder
    private var menu: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach([Options(title: "Notícias", selection: 0),
                         Options(title: "Vídeos", selection: 1)], id: \.self) { section in
                    Button(action: { selection = section.selection },
                           label: {
                        if selection == section.selection {
                            Text(section.title)
                                .foregroundStyle(.primary)
                        }
                        if selection != section.selection {
                            Text(section.title)
                                .roundedFullSize(fill: theme.button.primary.color ?? .blue)
                        }
                    })
                    .disabled(selection == section.selection)
                }
            }
            .padding(2)
        }
        .scrollBounceBehavior(.basedOnSize)
    }
}

extension FavouritesView {
    @ViewBuilder
    private var tabs: some View {
        if selection == 0 {
            NewsFavouritesView()
        } else {
            VideosFullscreenView(api: viewModel.videosViewModel.youtube, favorite: true, theme: theme)
                .environment(\.managedObjectContext, viewModel.videosViewModel.context)
        }
    }
}
