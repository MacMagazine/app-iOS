import CommonLibrary
import CoreData
import SwiftUI
import UIComponentsLibrary

public struct NewsFavouritesView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var viewModel: NewsViewModel
    @FetchRequest var news: FetchedResults<News>

    public init() {
        let request: NSFetchRequest<News> = News.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \News.pubDate, ascending: false)]
        _news = FetchRequest(fetchRequest: request)
    }

    public var body: some View {
        if news.filter({ $0.favorite }).isEmpty {
            ErrorView(message: "Nenhuma notícia favoritada.")
        }

        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 280),
                                         alignment: .top)]) {
                ForEach(news.filter { $0.favorite }, id: \.self) { object in
                    Button(action: {
                        viewModel.newsToShow = NewsToShow(title: object.title ?? "",
                                                          url: object.shortURL ?? "",
                                                          favorite: object.favorite,
                                                          action: { favorite in viewModel.storage.update(news: object, favorite: favorite) })
                    }, label: {
                        let filter: NewsViewModel.Category = viewModel.filter(source: object.allCategories)
                        if filter.style == .highlight {
                            GeometryReader { geo in
                                CardView(object: CardData(style: filter.style,
                                                          title: object.title,
                                                          creator: object.creator,
                                                          pubDate: object.pubDate(format: filter.dateFormat),
                                                          artworkURL: object.artworkURL,
                                                          width: filter.width ?? geo.size.width,
                                                          height: filter.height,
                                                          aspectRatio: filter.aspectRatio))
                            }
                            .aspectRatio(filter.aspectRatio, contentMode: .fit)
                        } else {
                            CardView(object: CardData(style: filter.style,
                                                      title: object.title,
                                                      creator: object.creator,
                                                      pubDate: object.pubDate(format: filter.dateFormat),
                                                      artworkURL: object.artworkURL,
                                                      width: filter.width ?? .infinity,
                                                      height: filter.height,
                                                      aspectRatio: filter.aspectRatio))
                        }
                    })
                }
            }
        }
    }
}

#Preview {
    let viewModel = NewsViewModel(inMemory: true)
    return ScrollView {
        NewsFavouritesView()
            .environment(\.managedObjectContext, viewModel.mainContext)
            .environmentObject(viewModel)
            .environment(\.theme, ThemeColor())
    }
}
