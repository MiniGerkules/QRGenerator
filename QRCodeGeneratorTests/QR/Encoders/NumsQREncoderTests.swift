//
//  NumsQREncoderTests.swift
//  QRCodeGeneratorTests
//
//  Created by Евгений Кацер on 16.09.2023.
//

import XCTest
@testable import QRCodeGenerator

final class NumsQREncoderTests: XCTestCase {
    private let encoder_ = NumsQREncoder()

    func testValidateDataWithDifferentData() {
        XCTAssertNoThrow(try encoder_.validateData(
            "012345689", correctionLevel: .L
        ))

        XCTAssertThrowsError(try encoder_.validateData(
            "123a456", correctionLevel: .L
        )) { guard case EncoderError.uncorrectData(_) = $0 else { return XCTFail() } }

        XCTAssertThrowsError(try encoder_.validateData(
            "123456-", correctionLevel: .L
        )) { guard case EncoderError.uncorrectData(_) = $0 else { return XCTFail() } }

        XCTAssertThrowsError(try encoder_.validateData(
            "123456%", correctionLevel: .L
        )) { guard case EncoderError.uncorrectData(_) = $0 else { return XCTFail() } }
    }

    func testValidateDataWithDifferentDataSizes() {
        XCTAssertThrowsError(try encoder_.validateData(
            "", correctionLevel: .L
        )) { guard case EncoderError.dataIsEmpty = $0 else { return XCTFail() } }

        var text = String(repeating: "0", count: 7088)
        XCTAssertNoThrow(try encoder_.validateData(
            text, correctionLevel: .L
        ))
        text = String(repeating: "0", count: 7089)
        XCTAssertThrowsError(try encoder_.validateData(
            text, correctionLevel: .L
        )) { guard case EncoderError.tooMuchData = $0 else { return XCTFail() } }

        text = String(repeating: "0", count: 5596)
        XCTAssertNoThrow(try encoder_.validateData(
            text, correctionLevel: .M
        ))
        text = String(repeating: "0", count: 5597)
        XCTAssertThrowsError(try encoder_.validateData(
            text, correctionLevel: .M
        )) { guard case EncoderError.tooMuchData = $0 else { return XCTFail() } }

        text = String(repeating: "0", count: 3992)
        XCTAssertNoThrow(try encoder_.validateData(
            text, correctionLevel: .Q
        ))
        text = String(repeating: "0", count: 3993)
        XCTAssertThrowsError(try encoder_.validateData(
            text, correctionLevel: .Q
        )) { guard case EncoderError.tooMuchData = $0 else { return XCTFail() } }

        text = String(repeating: "0", count: 3056)
        XCTAssertNoThrow(try encoder_.validateData(
            text, correctionLevel: .H
        ))
        text = String(repeating: "0", count: 3057)
        XCTAssertThrowsError(try encoder_.validateData(
            text, correctionLevel: .H
        )) { guard case EncoderError.tooMuchData = $0 else { return XCTFail() } }
    }

    func testGenerateQRBits() {
        var encoded = encoder_.generateQRBits(for: "123456789")
        XCTAssertEqual("000111101101110010001100010101", encoded)

        encoded = encoder_.generateQRBits(for: "12345678")
        XCTAssertEqual("000111101101110010001001110", encoded)

        encoded = encoder_.generateQRBits(for: "1234567")
        XCTAssertEqual("000111101101110010000111", encoded)

        encoded = encoder_.generateQRBits(for: "")
        XCTAssertEqual("", encoded)
    }
}
