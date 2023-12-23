import CommonLibrary
import SwiftUI

struct SectionsView: View {
	@Environment(\.theme) private var theme: ThemeColor
	@EnvironmentObject private var viewModel: MainViewModel

	var body: some View {
		ScrollView(.horizontal) {
			HStack {
				ForEach(viewModel.sections, id: \.id) { section in
					Button(action: { section.action() },
						   label: {
						Text(section.title)
							.plain(color: theme.text.terciary.color ?? .primary,
								   font: .body)
					})
				}
			}
		}
    }
}

#Preview {
	SectionsView()
}
