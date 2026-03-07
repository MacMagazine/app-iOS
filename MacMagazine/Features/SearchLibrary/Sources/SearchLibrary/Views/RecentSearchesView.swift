import SwiftUI

struct RecentSearchesView: View {
    let searches: [RecentSearchDB]
    let onSelect: (RecentSearchDB) -> Void
    let onClear: () -> Void
    let onRemove: (RecentSearchDB) -> Void

    var body: some View {
        if !searches.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Recentes")
                        .font(.headline)
                    Spacer()
                    Button("Limpar") { onClear() }
                        .font(.subheadline)
                }
                .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(searches) { search in
                            Button {
                                onSelect(search)
                            } label: {
                                Text(search.query)
                                .lineLimit(1)
                                .font(.headline)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .glassEffect(.clear, in: .capsule)
                            .contextMenu {
                                Button(role: .destructive) {
                                    onRemove(search)
                                } label: {
                                    Label("Remover", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
