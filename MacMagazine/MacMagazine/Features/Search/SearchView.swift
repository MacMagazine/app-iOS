import MacMagazineLibrary
import SearchLibrary
import StorageLibrary
import SwiftUI

struct SearchView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(MainViewModel.self) private var viewModel

    var body: some View {
        SearchLibrary.SearchView(storage: viewModel.storage)
    }
}
