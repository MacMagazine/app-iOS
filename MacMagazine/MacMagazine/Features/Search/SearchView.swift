import MacMagazineLibrary
import SearchLibrary
import SwiftUI

struct SearchView: View {
    @Environment(\.theme) private var theme: ThemeColor

    var body: some View {
        SearchLibrary.SearchView()
    }
}
