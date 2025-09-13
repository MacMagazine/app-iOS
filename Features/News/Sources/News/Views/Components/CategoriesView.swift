import CommonLibrary
import SwiftUI
import UIComponentsLibrary

public struct CategoriesView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var viewModel: NewsViewModel
    @State private var selected: NewsViewModel.Category = .all

    public var body: some View {
        MenuView(menu: NewsViewModel.Category.allCases.filter {
            ![.youtube, .podcast].contains($0)
        },
                 selected: $selected)

        .onChange(of: selected) { _, new in
            viewModel.options = .filter(category: new)
        }
    }

    public init() {}
}

#Preview {
	CategoriesView()
		.environment(\.theme, ThemeColor())
        .environmentObject(NewsViewModel(inMemory: true))
}
