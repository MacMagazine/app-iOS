import SwiftUI
import UIComponentsLibrary

struct ChaptersView: View {
    @Bindable private var playerManager: PodcastPlayerManager
    @Binding private var isShowingChapterDialog: Bool

    @State var backgroundGradientColors: [Color] = [.black, .black]
    @State var isDarkBackground: Bool = false

    private let backgroundGradientStyle: PodcastBackgroundGradientStyle

    init(
        playerManager: PodcastPlayerManager,
        backgroundGradientStyle: PodcastBackgroundGradientStyle,
        isShowingChapterDialog: Binding<Bool>
    ) {
        self.playerManager = playerManager
        self.backgroundGradientStyle = backgroundGradientStyle
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
        .onAppear {
            updateBackgroundGradient(data: playerManager.currentChapter?.artworkData)
        }
        .onChange(of: playerManager.currentChapter?.artworkData) { _, value in
            updateBackgroundGradient(data: value)
        }
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
                        } else if let url = URL(string: Constants.coverURL) {
                            CachedAsyncImage(image: url)
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
            .listRowBackground(chapter.backgroundColor(at: playerManager.currentTime, using: backgroundGradientColors))
            .accessibilityLabel("\(chapter.title), começando em \(chapter.startString) com duração de \(chapter.durationString).")
        }
        .scrollContentBackground(.hidden)
    }
}

private extension ChaptersView {
    func updateBackgroundGradient(
        data: Data? = nil
    ) {
        Task(priority: .background) {
            if let data {
                let gradient = await BackgroundGradient.updateBackgroundGradient(
                    data: data,
                    backgroundGradientStyle: backgroundGradientStyle
                )
                await MainActor.run {
                    backgroundGradientColors = gradient.colors
                    isDarkBackground = gradient.isDark
                }
            } else {
                let gradient = await BackgroundGradient.updateBackgroundGradient(
                    artworkURL: Constants.coverURL,
                    backgroundGradientStyle: backgroundGradientStyle
                )
                await MainActor.run {
                    backgroundGradientColors = gradient.colors
                    isDarkBackground = gradient.isDark
                }
            }
        }
    }
}
