import SwiftUI

struct SpeedWheelPicker<LeftIcon: View, RightIcon: View>: View {
    @Binding var value: Double

    private let minValue: Double
    private let maxValue: Double
    private let step: Double
    private let width: CGFloat

    private let leftIcon: LeftIcon
    private let rightIcon: RightIcon

    private let tickSpacing: CGFloat = 12
    private let majorModulo: Int = 5
    private let tickHeightMajor: CGFloat = 18
    private let tickHeightMinor: CGFloat = 10

    @State private var isLoaded = false

    init(
        value: Binding<Double>,
        minValue: Double,
        maxValue: Double,
        step: Double,
        width: CGFloat,
        @ViewBuilder leftIcon: () -> LeftIcon,
        @ViewBuilder rightIcon: () -> RightIcon
    ) {
        _value = value
        self.minValue = minValue
        self.maxValue = maxValue
        self.step = step
        self.width = width
        self.leftIcon = leftIcon()
        self.rightIcon = rightIcon()
    }

    var body: some View {
        HStack(spacing: 6) {
            Button { stepDown() } label: { leftIcon }
                .buttonStyle(.plain)

            GeometryReader { geo in
                let size = geo.size
                let horizontalPadding = size.width / 2

                ScrollView(.horizontal) {
                    HStack(spacing: tickSpacing) {
                        let totalSteps = Int(round((maxValue - minValue) / step))

                        ForEach(0...totalSteps, id: \.self) { idx in
                            let val = minValue + Double(idx) * step
                            let major = idx % majorModulo == 0

                            Divider()
                                .background(
                                    major
                                    ? Color.primary
                                    : Color.secondary.opacity(0.5)
                                )
                                .frame(
                                    width: 0,
                                    height: major ? tickHeightMajor : tickHeightMinor
                                )
                                .overlay(alignment: .bottom) {
                                    if major {
                                        Text(formattedLabel(val))
                                            .font(.system(size: 11))
                                            .fixedSize()
                                            .offset(y: 24)
                                    }
                                }
                        }
                    }
                    .offset(y: -18)
                    .frame(height: tickHeightMajor + 18)
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: scrollBinding)
                .safeAreaPadding(.horizontal, horizontalPadding)
                .overlay(alignment: .center) {
                    Rectangle()
                        .fill(Color.black)
                        .offset(y: -12)
                        .frame(width: 1, height: 30)
                }
                .onAppear {
                    DispatchQueue.main.async {
                        isLoaded = true
                    }
                }
            }
            .frame(height: 40)

            Button { stepUp() } label: { rightIcon }
                .buttonStyle(.plain)
        }
        .frame(width: width, height: 40)
    }

    // MARK: - SCROLL BINDING

    private var scrollBinding: Binding<Int?> {
        Binding<Int?>(
            get: {
                guard isLoaded else { return nil }
                return index(for: value)
            },
            set: { newIndex in
                guard let newIndex else { return }
                let total = Int(round((maxValue - minValue) / step))
                let clamped = min(max(newIndex, 0), total)
                let new = minValue + Double(clamped) * step
                if abs(new - value) > 0.0001 {
                    value = new
                }
            }
        )
    }

    // MARK: - HELPERS

    private func index(for value: Double) -> Int {
        let clamped = min(max(value, minValue), maxValue)
        let raw = (clamped - minValue) / step
        return Int(round(raw))
    }

    private func formattedLabel(_ val: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = .current
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.maximumFractionDigits = 1
        return (numberFormatter.string(from: NSNumber(value: val)) ?? "\(val)") + "x"
    }

    private func roundedToOneDecimal(_ value: Double) -> Double {
        let scale = 10.0
        return (value * scale).rounded() / scale
    }

    private func stepDown() {
        let decremented = value - step
        let clamped = max(minValue, decremented)
        let new = roundedToOneDecimal(clamped)

        if abs(new - value) > 0.0001 {
            value = new
            haptic()
        }
    }

    private func stepUp() {
        let incremented = value + step
        let clamped = min(maxValue, incremented)
        let new = roundedToOneDecimal(clamped)

        if abs(new - value) > 0.0001 {
            value = new
            haptic()
        }
    }

    private func haptic() {
        let haptic = UIImpactFeedbackGenerator(style: .light)
        haptic.impactOccurred()
    }
}

#Preview {
    struct Wrapper: View {
        @State var value: Double = 1.0

        var body: some View {
            VStack(spacing: 16) {
                SpeedWheelPicker(
                    value: $value,
                    minValue: 0.5,
                    maxValue: 3.0,
                    step: 0.1,
                    width: 280,
                    leftIcon: {
                        Image(systemName: "tortoise.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.primary)
                    },
                    rightIcon: {
                        Image(systemName: "hare.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.primary)
                    }
                )
            }
            .padding()
        }
    }
    return Wrapper()
}
