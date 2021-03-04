import Foundation
import OpenSSL

struct Payload {
    var bundleIdString: String?
    var bundleVersionString: String?
    var bundleIdData: Data?
    var hashData: Data?
    var opaqueData: Data?
    var expirationDate: Date?
    var receiptCreationDate: Date?
    var originalAppVersion: String?

    var inAppReceipts: [IAPReceipt] = []
}

class OpenSSLManager {
    static let shared = OpenSSLManager()

    var validContainer: UnsafeMutablePointer<PKCS7>?

    enum PayloadItemType: Int {
        case bundleIdentifier = 2
        case bundleVersion = 3
        case value = 4
        case guid = 5
        case creationDate = 12
        case iapRecceipt = 17
        case appVersion = 19
        case expirationDate = 21
    }

    // MARK: - RECEIPT -

    // Convert the Data receipt into a OpenSSL PKCS7
    func convert(receipt: Data) -> UnsafeMutablePointer<PKCS7>? {
        let receiptBIO = BIO_new(BIO_s_mem())
        let receiptBytes: [UInt8] = .init(receipt)
        BIO_write(receiptBIO, receiptBytes, Int32(receipt.count))

        let receiptPKCS7 = d2i_PKCS7_bio(receiptBIO, nil)
        BIO_free(receiptBIO)

        guard receiptPKCS7 != nil else {
            return nil
        }
        return receiptPKCS7
    }

    // Check that the container has a signature
    func hasSignature(container: UnsafeMutablePointer<PKCS7>) -> Bool {
        guard OBJ_obj2nid(container.pointee.type) == NID_pkcs7_signed else {
            return false
        }
        return true
    }

    // Check that the container contains data
    func hasData(container: UnsafeMutablePointer<PKCS7>) -> Bool {
        let receiptContents = container.pointee.d.sign.pointee.contents
        guard OBJ_obj2nid(receiptContents?.pointee.type) == NID_pkcs7_data else {
            return false
        }
        return true
    }

    // MARK: - CERTIFICATE -

    // Convert the Data receipt into a OpenSSL X509
    func convert(certificate: Data) -> OpaquePointer? {
        let rootCertBio = BIO_new(BIO_s_mem())
        let rootCertBytes: [UInt8] = .init(certificate)
        BIO_write(rootCertBio, rootCertBytes, Int32(certificate.count))

        let rootCertX509 = d2i_X509_bio(rootCertBio, nil)
        BIO_free(rootCertBio)

        guard rootCertX509 != nil else {
            return nil
        }
        return rootCertX509
    }

    func isValidReceipt(using rootCertX509: OpaquePointer) -> Bool {
        guard let receipt = validContainer else {
            return false
        }

        // Open certificate store
        let store = X509_STORE_new()
        X509_STORE_add_cert(store, rootCertX509)

        OPENSSL_init_crypto(UInt64(OPENSSL_INIT_ADD_ALL_DIGESTS), nil)

        // Verify receipt using root certificate
        let verificationResult = PKCS7_verify(receipt, nil, store, nil, nil, 0)
        guard verificationResult == 1  else {
            return false
        }
        return true
    }

    // MARK: - PAYLOAD -

    var payload: Payload? {
        // Get a pointer to the start and end of the ASN.1 payload
        let receiptSign = validContainer?.pointee.d.sign
        let octets = receiptSign?.pointee.contents.pointee.d.data
        var ptr = UnsafePointer(octets?.pointee.data)
        let end = ptr!.advanced(by: Int(octets!.pointee.length))

        var type: Int32 = 0
        var xclass: Int32 = 0
        var length: Int = 0

        ASN1_get_object(&ptr, &length, &type, &xclass, ptr!.distance(to: end))
        guard type == V_ASN1_SET else {
            return nil
        }

        var payload = Payload()

        while ptr! < end {
            ASN1_get_object(&ptr, &length, &type, &xclass, ptr!.distance(to: end))
            guard type == V_ASN1_SEQUENCE else {
                return nil
            }

            guard let _ = readASN1Integer(ptr: &ptr, maxLength: ptr!.distance(to: end)) else {
                return nil
            }

            // 5
            ASN1_get_object(&ptr, &length, &type, &xclass, ptr!.distance(to: end))
            guard type == V_ASN1_OCTET_STRING else {
                return nil
            }

            guard let attributeType = readASN1Integer(ptr: &ptr, maxLength: length) else {
                return nil
            }

            switch PayloadItemType(rawValue: attributeType) {
                case .bundleIdentifier:
                    var stringStartPtr = ptr
                    payload.bundleIdString = readASN1String(ptr: &stringStartPtr, maxLength: length)
                    payload.bundleIdData = readASN1Data(ptr: ptr!, length: length)

                case .bundleVersion:
                    var stringStartPtr = ptr
                    payload.bundleVersionString = readASN1String(ptr: &stringStartPtr, maxLength: length)

                case .value:
                    let dataStartPtr = ptr!
                    payload.opaqueData = readASN1Data(ptr: dataStartPtr, length: length)

                case .guid:
                    let dataStartPtr = ptr!
                    payload.hashData = readASN1Data(ptr: dataStartPtr, length: length)

                case .creationDate:
                    var dateStartPtr = ptr
                    payload.receiptCreationDate = readASN1Date(ptr: &dateStartPtr, maxLength: length)

                case .iapRecceipt:
                    var iapStartPtr = ptr
                    let parsedReceipt = IAPReceipt(with: &iapStartPtr, payloadLength: length)
                    if let newReceipt = parsedReceipt {
                        payload.inAppReceipts.append(newReceipt)
                    }

                case .appVersion:
                    var stringStartPtr = ptr
                    payload.originalAppVersion = readASN1String(ptr: &stringStartPtr, maxLength: length)

                case .expirationDate:
                    var dateStartPtr = ptr
                    payload.expirationDate = readASN1Date(ptr: &dateStartPtr, maxLength: length)

                default: // Ignore other attributes in receipt
                    print("Not processing attribute type: \(attributeType)")
            }

            // Advance pointer to the next item
            ptr = ptr!.advanced(by: length)
        }

        return payload
    }
}

extension OpenSSLManager {
    func computeHash(data: Data, bundleIdData: Data, opaqueData: Data) -> Data {
        var ctx = SHA_CTX()
        SHA1_Init(&ctx)

        let identifierBytes: [UInt8] = .init(data)
        SHA1_Update(&ctx, identifierBytes, data.count)

        let opaqueBytes: [UInt8] = .init(opaqueData)
        SHA1_Update(&ctx, opaqueBytes, opaqueData.count)

        let bundleBytes: [UInt8] = .init(bundleIdData)
        SHA1_Update(&ctx, bundleBytes, bundleIdData.count)

        var hash: [UInt8] = .init(repeating: 0, count: 20)
        SHA1_Final(&hash, &ctx)
        return Data(bytes: hash, count: 20)
    }
}
