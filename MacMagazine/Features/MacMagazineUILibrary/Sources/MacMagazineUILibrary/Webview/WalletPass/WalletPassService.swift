import Foundation
import NetworkLibrary
import PassKit

/// Downloads and parses an Apple Wallet pass (`.pkpass`) linked from web content.
///
/// Marked `@MainActor` because `PKPass` is not `Sendable` — parsing it must stay on the
/// same actor as the SwiftUI view that presents `PKAddPassesViewController`.
@MainActor
struct WalletPassService {
    private let network: Network & Sendable

    init(network: (Network & Sendable)? = nil) {
        self.network = network ?? NetworkFactory.make()
    }

    func fetchPass(from url: URL) async throws -> PKPass {
        let data = try await network.get(url: url, headers: [:])
        return try PKPass(data: data)
    }
}
