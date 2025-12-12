import FeedLibrary
import StorageLibrary
import SwiftUI

struct ContentView: View {
    let viewModel = FeedViewModel(
        storage: Database(models: [FeedDB.self], inMemory: true)
    )

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            let feed = try? await viewModel.getWatchFeed()
            print(feed?.map { $0.title } ?? "")
        }
    }
}

#Preview {
    ContentView()
}
