//
//  BytesQREncoder.swift
//  QRCodeGeneratorTests
//
//  Created by Евгений Кацер on 17.09.2023.
//

import XCTest
@testable import QRCodeGenerator

final class BytesQREncoderTests: XCTestCase {
    private let encoder_ = BytesQREncoder()

    func testValidateDataWithDifferentDataSizes() {
        XCTAssertThrowsError(try encoder_.validateData(
            "", correctionLevel: .L
        )) { guard case EncoderError.dataIsEmpty = $0 else { return XCTFail() } }

        var text = String(repeating: "0", count: 2953)
        XCTAssertNoThrow(try encoder_.validateData(
            text, correctionLevel: .L
        ))
        text = String(repeating: "0", count: 2954)
        XCTAssertThrowsError(try encoder_.validateData(
            text, correctionLevel: .L
        )) { guard case EncoderError.tooMuchData = $0 else { return XCTFail() } }

        text = String(repeating: "0", count: 2331)
        XCTAssertNoThrow(try encoder_.validateData(
            text, correctionLevel: .M
        ))
        text = String(repeating: "0", count: 2332)
        XCTAssertThrowsError(try encoder_.validateData(
            text, correctionLevel: .M
        )) { guard case EncoderError.tooMuchData = $0 else { return XCTFail() } }

        text = String(repeating: "0", count: 1663)
        XCTAssertNoThrow(try encoder_.validateData(
            text, correctionLevel: .Q
        ))
        text = String(repeating: "0", count: 1664)
        XCTAssertThrowsError(try encoder_.validateData(
            text, correctionLevel: .Q
        )) { guard case EncoderError.tooMuchData = $0 else { return XCTFail() } }

        text = String(repeating: "0", count: 1273)
        XCTAssertNoThrow(try encoder_.validateData(
            text, correctionLevel: .H
        ))
        text = String(repeating: "0", count: 1274)
        XCTAssertThrowsError(try encoder_.validateData(
            text, correctionLevel: .H
        )) { guard case EncoderError.tooMuchData = $0 else { return XCTFail() } }
    }

    func testGenerateQRBits() {
        var generate = "123456789"
        var mustBe = generate.utf8.map { $0.toBinString() }.joined()
        var encoded = encoder_.generateQRBits(for: generate)
        XCTAssertEqual(mustBe, encoded)

        generate = "\"letters\" and %digits0%"
        mustBe = generate.utf8.map { $0.toBinString() }.joined()
        encoded = encoder_.generateQRBits(for: generate)
        XCTAssertEqual(mustBe, encoded)

        generate = "И даже кириллица."
        mustBe = generate.utf8.map { $0.toBinString() }.joined()
        encoded = encoder_.generateQRBits(for: generate)
        XCTAssertEqual(mustBe, encoded)

        encoded = encoder_.generateQRBits(for: "")
        XCTAssertEqual("", encoded)
    }
}
