//
//  LettersAndNumsQREncoder.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 07.09.2023.
//

import UIKit.UIImage

struct LettersAndNumsQREncoder : QREncoder {
    //MARK: - Static fields
    private static let codingTable_: [Character : Int] = [
        "0" : 0, "1" : 1, "2" : 2, "3" : 3, "4" : 4, "5" : 5, "6" : 6, "7" : 7,
        "8" : 8, "9" : 9, "A" : 10, "B" : 11, "C" : 12, "D" : 13, "E" : 14,
        "F" : 15, "G" : 16, "H" : 17, "I" : 18, "J" : 19, "K" : 20, "L" : 21,
        "M" : 22, "N" : 23, "O" : 24, "P" : 25, "Q" : 26, "R" : 27, "S" : 28,
        "T" : 29, "U" : 30, "V" : 31, "W" : 32, "X" : 33, "Y" : 34, "Z" : 35,
        " " : 36, "$" : 37, "%" : 38, "*" : 39, "+" : 40, "-" : 41, "." : 42,
        "/" : 43, ":" : 44
    ]

    private static let twoCharsBlockSize_ = 11
    private static let oneCharBlockSize_ = 6

    //MARK: - Static methods for encoding characters to qr bits
    private static func encode(first: Character, second: Character) -> Int {
        return 45*Self.codingTable_[first]! + Self.codingTable_[second]!
    }

    private static func encode(first: Character) -> Int {
        return Self.codingTable_[first]!
    }

    //MARK: - QREncoder protocol overrides
    static let dataDesc: String = "Letters, numbers"
    static let qrEncodingID: String = "0010"

    func dataContentValid(_ data: String) throws {
        if data.contains(/[^0-9a-zA-Z $%*+\-.\/:]/) {
            throw EncoderError.uncorrectData("Data contains not only digits, english " +
                                             "letters, spaces or that characters: '$', " +
                                             "'%', '*', '+', '-', '.', '/', ':'!")
        }
    }

    func getMaxEncodedSize(of data: String) -> Int {
        let sizeFieldLen = getLengthOfSizeField(for: QRConstants.maxQRVersion)
        return 11*getDataSize(data)/2 + Self.qrEncodingID.count + sizeFieldLen
    }

    func generateQRBits(for data: String) -> String {
        guard !data.isEmpty else { return "" }

        var qrBits = String()
        let chunks = data.uppercased().split(by: 2)!

        for chunk in chunks.dropLast() {
            let encoded = Self.encode(first: chunk.first!, second: chunk.last!)
            qrBits += encoded.toBinString().suffix(Self.twoCharsBlockSize_)
        }

        let lastChunk = chunks.last!
        if lastChunk.count == 2 { // 2 chars
            let encoded = Self.encode(first: lastChunk.first!, second: lastChunk.last!)
            qrBits += encoded.toBinString().suffix(Self.twoCharsBlockSize_)
        } else { // 1 char
            let encoded = Self.encode(first: lastChunk.first!)
            qrBits += encoded.toBinString().suffix(Self.oneCharBlockSize_)
        }

        return qrBits
    }

    func getLengthOfSizeField(for qrVersion: QRVersion) -> Int {
        if (1...9).contains(qrVersion.value) {
            return 9
        } else if (10...26).contains(qrVersion.value) {
            return 11
        } else {
            return 13
        }
    }
}
