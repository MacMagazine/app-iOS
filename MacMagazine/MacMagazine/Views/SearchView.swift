import CommonLibrary
import CoreData
import News
import SwiftUI
import UIComponentsLibrary
import UIComponentsLibrarySpecial

struct SearchView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var newsViewModel: NewsViewModel
    
    @Binding var searchText: String
    @State private var searchResults: [News] = []
    @State private var isSearching: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                theme.main.background.color
                    .ignoresSafeArea()
                
                VStack {
                    if searchText.isEmpty {
                        // Empty state
                        VStack(spacing: 16) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 64))
//                                .foregroundStyle(theme.main.text.secondary.color)
                            
                            Text("Search for news, videos, and more")
                                .font(.title3)
//                                .foregroundStyle(theme.main.text.secondary.color)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // Search results
                        if isSearching {
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else if searchResults.isEmpty {
                            // No results
                            VStack(spacing: 16) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 48))
//                                    .foregroundStyle(theme.main.text.secondary.color)
                                
                                Text("No results found")
                                    .font(.title3)
//                                    .foregroundStyle(theme.main.text.secondary.color)
                                
                                Text("Try a different search term")
                                    .font(.body)
//                                    .foregroundStyle(theme.main.text.tertiary.color)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            // Results list
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 280), alignment: .top)]) {
                                ForEach(searchResults, id: \.self) { object in
                                    Button(action: {
                                    }, label: {
                                            Text(object.title ?? "")
                                    })
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
        .onChange(of: searchText) { _, newValue in
            performSearch(query: newValue)
        }
    }
    
    private func performSearch(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        
        // Perform Core Data search
        let fetchRequest: NSFetchRequest<News> = News.fetchRequest()
        
        // Create predicate to search in title and description
        let predicate = NSPredicate(
            format: "title CONTAINS[cd] %@ OR content CONTAINS[cd] %@",
            query, query
        )
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \News.pubDate, ascending: false)]
        fetchRequest.fetchLimit = 50 // Limit results for performance
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            do {
                searchResults = try viewContext.fetch(fetchRequest)
            } catch {
                print("Search error: \(error)")
                searchResults = []
            }
            isSearching = false
        }
    }
}

#Preview {
    SearchView(searchText: .constant(""))
        .environmentObject(NewsViewModel(inMemory: true))
        .environment(\.theme, ThemeColor())
}
