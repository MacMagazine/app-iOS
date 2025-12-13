import MacMagazineLibrary
import SwiftUI

struct ChaptersView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.theme) private var theme
    @Bindable private var playerManager: PodcastPlayerManager
    @Binding private var isShowingChapterDialog: Bool

    init(
        playerManager: PodcastPlayerManager,
        isShowingChapterDialog: Binding<Bool>
    ) {
        self.playerManager = playerManager
        _isShowingChapterDialog = isShowingChapterDialog
    }

    var body: some View {
        NavigationStack {
            chapters
                .navigationTitle(playerManager.currentPodcast?.title ?? "")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}

private extension ChaptersView {
    @ViewBuilder
    var chapters: some View {
        List(playerManager.chapters, id: \.id) { chapter in
            Button(action: {
                playerManager.seek(to: chapter.start.seconds)
                isShowingChapterDialog.toggle()
            }, label: {
                HStack {
                    if let artworkData = chapter.artworkData,
                       let uiImage = UIImage(data: artworkData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 45)
                            .cornerRadius(8)
                    }

                    VStack(alignment: .leading) {
                        Text(chapter.title).bold().font(.body)
                        Text("Duração: \(chapter.durationString)").font(.footnote)
                    }
                    Spacer()
                    Text(chapter.startString).font(.body)
                }
            })
            .listRowBackground(chapter.backgroundColor(at: playerManager.currentTime))
            .accessibilityLabel("\(chapter.title), começando em \(chapter.startString) com duração de \(chapter.durationString).")
        }
    }
}
