import InAppLibrary

@MainActor
public protocol InAppManaging: AnyObject {
    var status: InAppStatus { get set }
    var canPurchase: Bool { get }

    func getProducts(for identifiers: [String]) async throws -> [InAppProduct]
    func purchase(_ product: InAppProduct) async
    func restore() async
}

extension InAppManager: InAppManaging {}
