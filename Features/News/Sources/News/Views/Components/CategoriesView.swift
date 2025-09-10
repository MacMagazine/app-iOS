import CommonLibrary
import SwiftUI
import UIComponentsLibrary

public struct CategoriesView: View {
	@Environment(\.theme) private var theme: ThemeColor
	@EnvironmentObject private var viewModel: NewsViewModel

	public init() {}

	public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(NewsViewModel.Category.allCases, id: \.self) { category in
                    if ![.all, .youtube, .podcast].contains(where: { $0 == category }) {
                        Button(action: {
                            switch viewModel.options {
                            case .filter(let option):
                                if option == category {
                                    viewModel.options = .all
                                } else {
                                    viewModel.options = .filter(category: category)
                                }
                            default:
                                viewModel.options = .filter(category: category)
                            }
                        },
                               label: {
                            Text(category.title)
                                .borderedFullSize(color: color(category: category),
                                                  stroke: stroke(category: category),
                                                  fill: fill(category: category))
                                .padding(.vertical, 6)
                        })
                    }
                }
            }
        }
    }
}

private extension CategoriesView {
    func isSelected(category: NewsViewModel.Category) -> Bool {
        switch viewModel.options {
        case .filter(let option): option == category
        default: false
        }
    }

    func color(category: NewsViewModel.Category) -> Color {
        if isSelected(category: category) {
            theme.text.secondary.color ?? .blue
        } else {
            theme.text.primary.color ?? .black
        }
    }

    func stroke(category: NewsViewModel.Category) -> Color {
        if isSelected(category: category) {
            theme.text.primary.color ?? .blue
        } else {
            theme.text.primary.color ?? .black
        }
    }

    func fill(category: NewsViewModel.Category) -> Color {
        if isSelected(category: category) {
            theme.text.primary.color ?? .blue
        } else {
            .clear
        }
    }
}

#Preview {
	CategoriesView()
		.environment(\.theme, ThemeColor())
        .environmentObject(NewsViewModel(inMemory: true))
}
