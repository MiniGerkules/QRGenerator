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

    func getDataSize(_ data: String) -> Int {
        return data.utf8.count
    }

    func validateData(_ data: String, correctionLevel: QRConstants.CorrectionLevel) throws {
        if data.isEmpty {
            throw EncoderError.dataIsEmpty
        }

        let maxPossibleSize = 8*data.utf8.count + Self.qrEncodingID.count +
            getLengthOfSizeField(for: QRVersion(version: QRConstants.versions.upperBound)!)
        if maxPossibleSize >= QRConstants.maxDataSize[correctionLevel]!.last! {
            throw EncoderError.tooMuchData
        }
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
