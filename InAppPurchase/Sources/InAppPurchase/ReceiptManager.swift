import Combine
import Foundation
import StoreKit

public enum ReceiptStatus {
    case notPresent
    case unknownFormat
    case invalidSignature
    case invalidDataType
    case invalidAppleRootCertificate
    case failedVerifyAppleSignature
    case missingComponent
    case invalidBundleIdentifier
    case invalidHash
    case expired
    case validationSuccess
}

class ReceiptManager: NSObject, ObservableObject {

    static let shared = ReceiptManager()

    @Published var status: ReceiptStatus?

    func readReceipt() {
        if hasValidReceipt &&
            hasValidSigning,
           let payload = OpenSSLManager.shared.payload {
            status = validate(receipt: payload)
        }
    }

    var hasValidReceipt: Bool {
        // Load the receipt
        guard let receiptUrl = Bundle.main.appStoreReceiptURL,
              let receiptData = try? Data(contentsOf: receiptUrl) else {
            status = .notPresent
            return false
        }

        // Convert from Data to PKCS7
        guard let pkcs7 = OpenSSLManager.shared.convert(receipt: receiptData) else {
            status = .unknownFormat
            return false
        }

        // Verify the container has both signature and data
        if !OpenSSLManager.shared.hasSignature(container: pkcs7) {
            status = .invalidSignature
            return false
        }

        if !OpenSSLManager.shared.hasData(container: pkcs7) {
            status = .invalidDataType
            return false
        }

        OpenSSLManager.shared.validContainer = pkcs7

        return true
    }

    var hasValidSigning: Bool {
        // Get Apple certificate
        guard let rootCertUrl = Bundle.module.url(forResource: "AppleIncRootCertificate", withExtension: "cer"),
              let rootCertData = try? Data(contentsOf: rootCertUrl) else {
            status = .invalidAppleRootCertificate
            return false
        }

        // Convert from Data to X509
        guard let rootCertX509 = OpenSSLManager.shared.convert(certificate: rootCertData) else {
            status = .unknownFormat
            return false
        }

        let isValidReceipt = OpenSSLManager.shared.isValidReceipt(using: rootCertX509)
        if !isValidReceipt {
            status = .failedVerifyAppleSignature
        }
        return isValidReceipt
    }

    private func validate(receipt: Payload) -> ReceiptStatus {
        guard let idString = receipt.bundleIdString,
              let version = receipt.bundleVersionString,
              let _ = receipt.opaqueData,
              let hash = receipt.hashData,
              let bundleIdData = receipt.bundleIdData,
              let opaqueData = receipt.opaqueData
        else {
            return .missingComponent
        }

        guard let appBundleId = Bundle.main.bundleIdentifier,
            idString == appBundleId,
            let appVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String,
            version == appVersionString
        else {
            return .invalidBundleIdentifier
        }

        // Check the GUID hash
        let guidHash = OpenSSLManager.shared.computeHash(data: getDeviceIdentifier(),
                                                         bundleIdData: bundleIdData,
                                                         opaqueData: opaqueData)
        guard hash == guidHash else {
            return .invalidHash
        }

        // Check the expiration attribute if it's present
        let currentDate = Date()
        if let expirationDate = receipt.expirationDate {
            if expirationDate < currentDate {
                return .expired
            }
        }

        // All checks passed so validation is a success
        return .validationSuccess
    }
}

extension ReceiptManager {
    private func getDeviceIdentifier() -> Data {
        let device = UIDevice.current
        var uuid = device.identifierForVendor!.uuid
        let addr = withUnsafePointer(to: &uuid) { (p) -> UnsafeRawPointer in
            UnsafeRawPointer(p)
        }
        let data = Data(bytes: addr, count: 16)
        return data
    }
}
