import CommonLibrary
import SwiftUI

public struct IconsView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var viewModel: SettingsViewModel

    public init() {
    }

    public var body: some View {
        HStack(spacing: 30) {
            Spacer()

            ForEach(IconType.allCases, id: \.self) { type in
                Button(action: {
                    Task { await viewModel.change(type) }
                }, label: {
                    Image(type.rawValue, bundle: .module)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                })
                .frame(width: 70, height: 70)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12,
                                          style: .continuous)
                    .stroke(theme.text.primary.color ?? .blue, lineWidth: viewModel.icon == type ? 3 : 0)
                )
                .disabled(viewModel.icon == type)
                .opacity(viewModel.icon == type ? 0.5 : 1)
                .accessibilityLabel(type.accessibilityText(selected: viewModel.icon == type))
            }

            Spacer()
        }
    }
}

#Preview {
    VStack {
        IconsView()
        Spacer()
    }
    .padding()
    .environment(\.theme, ThemeColor())
    .environmentObject(SettingsViewModel())
}
