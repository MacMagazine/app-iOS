import CommonLibrary
import CoreData
import SwiftUI
import UIComponentsLibrary

struct NewsFullView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var viewModel: NewsViewModel
    @FetchRequest var news: FetchedResults<News>
    
    private let filter: NewsViewModel.Category
    private let limit: Int?
    
    init(filter: NewsViewModel.Category,
         limit: Int? = nil) {
        let request: NSFetchRequest<News> = News.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \News.pubDate, ascending: false)]
        _news = FetchRequest(fetchRequest: request)
        
        self.filter = filter
        self.limit = limit
    }
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 280),
                                     alignment: .top)]) {
            ForEach(news.filter { filter.filter(source: $0.allCategories) }.prefix(limit ?? news.count), id: \.self) { object in
                Button(action: {
                    viewModel.newsToShow = NewsToShow(title: object.title ?? "",
                                                      url: object.shortURL ?? "",
                                                      favorite: object.favorite,
                                                      action: { favorite in viewModel.storage.update(news: object, favorite: favorite) })
                }, label: {
                    let style = if filter == .all {
                        viewModel.filter(source: object.allCategories)
                    } else {
                        filter
                    }

                    switch style {
                    case .highlights, .reviews:
                        GeometryReader { geo in
                            CardView(object: CardData(style: style.style,
                                                      title: object.title,
                                                      creator: object.creator,
                                                      pubDate: object.pubDate(format: style.dateFormat),
                                                      artworkURL: object.artworkURL,
                                                      width: style.width ?? geo.size.width,
                                                      height: style.height,
                                                      aspectRatio: style.aspectRatio))
                        }
                        .aspectRatio(style.aspectRatio, contentMode: .fit)

                    default:
                        CardView(object: CardData(style: style.style,
                                                  title: object.title,
                                                  creator: object.creator,
                                                  pubDate: object.pubDate(format: style.dateFormat),
                                                  artworkURL: object.artworkURL,
                                                  width: style.width ?? .infinity,
                                                  height: style.height,
                                                  aspectRatio: style.aspectRatio))
                    }
                })
                .padding(.horizontal)
            }
        }
    }
}

#Preview("todas") {
    let viewModel = NewsViewModel(inMemory: true)
    return ScrollView {
        NewsFullView(filter: .all)
            .environment(\.managedObjectContext, viewModel.mainContext)
            .environmentObject(viewModel)
            .environment(\.theme, ThemeColor())

    }
    .task {
        try? await viewModel.getNews()
    }
}

#Preview("news") {
    let viewModel = NewsViewModel(inMemory: true)
    return ScrollView {
        NewsFullView(filter: .news)
            .environment(\.managedObjectContext, viewModel.mainContext)
            .environmentObject(viewModel)
            .environment(\.theme, ThemeColor())
        
    }
    .task {
        try? await viewModel.getNews()
    }
}

#Preview("highlights") {
    let viewModel = NewsViewModel(inMemory: true)
    return ScrollView {
        NewsFullView(filter: .highlights)
            .environment(\.managedObjectContext, viewModel.mainContext)
            .environmentObject(viewModel)
            .environment(\.theme, ThemeColor())
        
    }
    .task {
        try? await viewModel.getNews()
    }
}

#Preview("tutoriais") {
    let viewModel = NewsViewModel(inMemory: true)
    return ScrollView {
        NewsFullView(filter: .tutoriais)
            .environment(\.managedObjectContext, viewModel.mainContext)
            .environmentObject(viewModel)
            .environment(\.theme, ThemeColor())
        
    }
    .task {
        try? await viewModel.getNews()
    }
}
