//
//  BytesQREncoder.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 17.09.2023.
//

struct BytesQREncoder: QREncoder {
    //MARK: - QREncoder protocol overrides
    static var dataDesc: String = "Any data"
    static var qrEncodingID: String = "0100"

    func dataContentValid(_ data: String) throws {
        // Any content is valid
    }
    
    func getDataSize(_ data: String) -> Int {
        return data.utf8.count
    }

    func getMaxEncodedSize(of data: String) -> Int {
        let sizeFieldLen = getLengthOfSizeField(for: QRConstants.maxQRVersion)
        return 8*getDataSize(data) + Self.qrEncodingID.count + sizeFieldLen
    }

    func generateQRBits(for data: String) -> String {
        guard !data.isEmpty else { return "" }

        return data.utf8.map { $0.toBinString() }.joined()
    }

    func getLengthOfSizeField(for qrVersion: QRVersion) -> Int {
        if (1...9).contains(qrVersion.value) {
            return 8
        } else {
            return 16
        }
    }
}
