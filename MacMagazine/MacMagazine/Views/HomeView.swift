import CommonLibrary
import News
import SwiftUI
import Videos

struct HomeView: View {
    @EnvironmentObject private var viewModel: MainViewModel
    @State private var availableWidth: CGFloat = .infinity

    var body: some View {
        GeometryReader { geo in
            NewsView(fit: availableWidth)
            .task {
                availableWidth = geo.size.width
            }
            .onChange(of: geo.size.width) { _, value in
                availableWidth = value
            }
        }
        .environment(\.managedObjectContext, viewModel.newsViewModel.mainContext)
    }
}

#Preview {
    let viewModel = MainViewModel()
    return HomeView()
        .environmentObject(viewModel)
        .environmentObject(VideosViewModel())
        .environmentObject(NewsViewModel(inMemory: true))
        .environment(\.theme, ThemeColor())
}
