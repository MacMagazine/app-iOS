import MacMagazineLibrary
import SwiftUI

public enum SettingsViewType {
    case custom
    case native
}

public struct SettingsView: View {
    @Environment(\.theme) var theme: ThemeColor
    @State var scrollOffset: CGFloat = 0
    @State var headerHeight: CGFloat = 60

    let type: SettingsViewType

    public init(type: SettingsViewType) {
        self.type = type
    }

    public var body: some View {
        switch type {
        case .custom: customView
        case .native: nativeView
        }
    }
}

extension SettingsView {
    var headerScale: CGFloat {
        let scaleDistance: CGFloat = 100
        let scale = max(0.8, min(1, 1 - (scrollOffset / scaleDistance) * 0.2))
        return scale
    }

    // Calculate header opacity and scale based on scroll offset
    var headerOpacity: Double {
        let fadeDistance: CGFloat = 100
        let opacity = max(0, min(1, 1 - (scrollOffset / fadeDistance)))
        return opacity
    }

    var logo: some View {
        VStack {
            LogoMenuView()
                .background(
                    (theme.main.background.color ?? Color(uiColor: .systemGray6))
                        .opacity(0.95)
                )
                .opacity(headerOpacity)
                .scaleEffect(headerScale, anchor: .top)
                .animation(.easeInOut(duration: 0.2), value: scrollOffset)
        }
        .allowsHitTesting(false)
    }
}

struct LogoMenuView: View {
    @Environment(\.theme) private var theme: ThemeColor

    var body: some View {
        HStack {
            Image("menu")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 28)

            Image("MacMagazine")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 24)
                .padding(.top, 10)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
}
