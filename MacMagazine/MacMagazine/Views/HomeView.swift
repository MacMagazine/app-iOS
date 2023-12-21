import CommonLibrary
import SwiftUI
import Videos

struct HomeView: View {
	@State private var availableWidth: CGFloat = .infinity

	var body: some View {
		GeometryReader { geo in
			ScrollView {

				VideosView(availableWidth: availableWidth)

			}
			.onChange(of: geo.size.width) { value in
				availableWidth = value
			}
		}
	}
}

#Preview {
	HomeView()
		.environmentObject(VideosViewModel())
}
