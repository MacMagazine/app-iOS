import MacMagazineLibrary
import StorageLibrary
import SwiftUI
import UIComponentsLibrary
import VideosLibrary

struct SocialView: View {
    enum Options: String, CaseIterable {
        case videos = "Videos"
        case podcast = "Podcast"
        case instagram = "Instagram"
    }

    @Environment(\.theme) private var theme: ThemeColor
    @State private var selected = Options.videos
    @State private var favorite = false
    let storage: Database

    var body: some View {
        NavigationStack {
            ZStack {
                (theme.main.background.color ?? Color.secondary).ignoresSafeArea()
                content
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    menuView
                }
                ToolbarItem(placement: .principal) {
                    optionsView
                }
            }
        }
    }
}

private extension SocialView {
    var optionsView: some View {
        Picker("", selection: $selected) {
            ForEach(Options.allCases, id: \.self) { option in
                Text(option.rawValue).tag(option)
            }
        }
        .pickerStyle(.segmented)
    }

    @ViewBuilder
    var content: some View {
        switch selected {
        case .videos: VideosView(storage: storage, favorite: $favorite).transition(.opacity)
        case .podcast: Text("Podcast")
        case .instagram: Text("Instagram")
        }
    }

    var menuView: some View {
        Button(action: {
            withAnimation {
                favorite.toggle()
            }
        }, label: {
            Image(systemName: favorite ? "star.fill" : "star")
        })
    }
}

#Preview {
    let storage = Database(models: [], inMemory: true)
    SocialView(storage: storage)
        .environment(\.theme, ThemeColor())
}
