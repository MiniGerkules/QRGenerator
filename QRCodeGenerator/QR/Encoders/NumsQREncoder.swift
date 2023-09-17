//
//  NumberQREncoder.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 07.09.2023.
//

import UIKit.UIImage

struct NumsQREncoder : QREncoder {
    //MARK: - Static fields
    private static let threeDigitsBlockSize_ = 10
    private static let twoDigitsBlockSize_ = 7
    private static let oneDigitBlockSize_ = 4

    //MARK: - QREncoder protocol overrides
    static let dataDesc: String = "Numbers"
    static let qrEncodingID: String = "0001"

    func dataContentValid(_ data: String) throws {
        if data.contains(/[^\d]/) {
            throw EncoderError.uncorrectData("Data contains not only digits!")
        }
    }

    func getMaxEncodedSize(of data: String) -> Int {
        let sizeFieldLen = getLengthOfSizeField(for: QRConstants.maxQRVersion)
        return 10*getDataSize(data)/3 + Self.qrEncodingID.count + sizeFieldLen
    }

    func generateQRBits(for data: String) -> String {
        guard !data.isEmpty else { return "" }

        var qrBits = String()
        let chunks = data.split(by: 3)!.map{ Int($0)! }

        for chunk in chunks.dropLast() {
            qrBits += chunk.toBinString().suffix(Self.threeDigitsBlockSize_)
        }

        let lastChunk = chunks.last!
        if lastChunk / 100 != 0 { // 3 digits
            qrBits += lastChunk.toBinString().suffix(Self.threeDigitsBlockSize_)
        } else if lastChunk / 10 != 0 { // 2 digits
            qrBits += lastChunk.toBinString().suffix(Self.twoDigitsBlockSize_)
        } else { // 1 digit
            qrBits += lastChunk.toBinString().suffix(Self.oneDigitBlockSize_)
        }

        return qrBits
    }

    func getLengthOfSizeField(for qrVersion: QRVersion) -> Int {
        if (1...9).contains(qrVersion.value) {
            return 10
        } else if (10...26).contains(qrVersion.value) {
            return 12
        } else {
            return 14
        }
    }
}
