import SwiftUI

struct ChaptersView: View {
    @Bindable private var playerManager: PodcastPlayerManager
    @Binding private var isShowingChapterDialog: Bool

    let backgroundGradientColors: [Color]
    let isDarkBackground: Bool

    init(
        playerManager: PodcastPlayerManager,
        backgroundGradientColors: [Color],
        isDarkBackground: Bool,
        isShowingChapterDialog: Binding<Bool>
    ) {
        self.playerManager = playerManager
        self.backgroundGradientColors = backgroundGradientColors
        self.isDarkBackground = isDarkBackground
        _isShowingChapterDialog = isShowingChapterDialog
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: backgroundGradientColors),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            chapters
        }
        .preferredColorScheme(isDarkBackground ? .dark : .light)
    }
}

private extension ChaptersView {
    var chapters: some View {
        List(playerManager.chapters, id: \.id) { chapter in
            Button(action: {
                playerManager.seek(to: chapter.start.seconds)
                isShowingChapterDialog.toggle()
            }, label: {
                HStack(spacing: 20) {
                    Group {
                        if let artworkData = chapter.artworkData,
                           let uiImage = UIImage(data: artworkData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Rectangle().fill(.clear)
                        }
                    }
                    .frame(width: 45, height: 45)
                    .cornerRadius(8)

                    VStack(alignment: .leading, spacing: 10) {
                        Text(chapter.title).bold().font(.body)

                        HStack(spacing: 10) {
                            HStack(spacing: 4) {
                                Image(systemName: "clock").font(.system(size: 14))
                                Text(chapter.startString)
                            }
                            HStack(spacing: 4) {
                                Image(systemName: "microphone").font(.system(size: 14))
                                Text(chapter.durationString)
                            }
                            Spacer()
                        }
                        .font(.callout)
                    }
                }
            })
            .listRowBackground(chapter.backgroundColor(at: playerManager.currentTime))
            .accessibilityLabel("\(chapter.title), começando em \(chapter.startString) com duração de \(chapter.durationString).")
        }
        .scrollContentBackground(.hidden)
    }
}
