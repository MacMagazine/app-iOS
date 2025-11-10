import SwiftUI

extension SubscriptionView {
    var nativeView: some View {
        Section {
            if viewModel.isPatrao {
                logoffPatrao

            } else if viewModel.isValidSubscription {
                manageSubscription

            } else {
                purchaseOptions
                loginPatrao
            }

        } header: {
            headerContent(icon: false)
        } footer: {
            footer
        }
    }
}
