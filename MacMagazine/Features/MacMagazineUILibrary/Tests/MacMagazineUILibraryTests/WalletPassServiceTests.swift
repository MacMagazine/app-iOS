import Foundation
@testable import MacMagazineUILibrary
import NetworkLibrary
import Testing

@Suite("WalletPassService Tests")
@MainActor
struct WalletPassServiceTests {

    @Test("fetchPass propagates a network failure")
    func fetchPassNetworkFailure() async {
        let sut = WalletPassService(network: FailingNetworkStub())

        await #expect(throws: NetworkAPIError.self) {
            _ = try await sut.fetchPass(from: URL(string: "https://macmagazine.com.br/pass.pkpass")!)
        }
    }

    @Test("fetchPass throws when the downloaded data is not a valid pass")
    func fetchPassInvalidData() async {
        let sut = WalletPassService(network: StubNetwork(data: Data("not a pkpass".utf8)))

        await #expect(throws: (any Error).self) {
            _ = try await sut.fetchPass(from: URL(string: "https://macmagazine.com.br/pass.pkpass")!)
        }
    }
}

// MARK: - Test Doubles

private struct StubNetwork: Network, Sendable {
    let customHost: CustomHost? = nil
    let data: Data

    func get(url: URL, headers: [String: String]?) async throws -> Data { data }
    func post(url: URL, headers: [String: String]?, body: Data) async throws -> Data { data }
    func ping(url: URL) async throws {}
}

private struct FailingNetworkStub: Network, Sendable {
    let customHost: CustomHost? = nil

    func get(url: URL, headers: [String: String]?) async throws -> Data { throw NetworkAPIError.network }
    func post(url: URL, headers: [String: String]?, body: Data) async throws -> Data { throw NetworkAPIError.network }
    func ping(url: URL) async throws { throw NetworkAPIError.network }
}
