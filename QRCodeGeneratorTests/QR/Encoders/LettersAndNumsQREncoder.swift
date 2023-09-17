//
//  LettersQREncoderTests.swift
//  QRCodeGeneratorTests
//
//  Created by Евгений Кацер on 16.09.2023.
//

import XCTest
@testable import QRCodeGenerator

final class LettersAndNumsQREncoderTests: XCTestCase {
    private let encoder_ = LettersAndNumsQREncoder()

    func testValidateDataWithDifferentData() {
        XCTAssertNoThrow(try encoder_.validateData(
            "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM0 $%*+-./: 12345689",
            correctionLevel: .L
        ))

        XCTAssertThrowsError(try encoder_.validateData(
            "asdf123_", correctionLevel: .L
        )) { guard case EncoderError.uncorrectData(_) = $0 else { return XCTFail() } }

        XCTAssertThrowsError(try encoder_.validateData(
            "903)fjds", correctionLevel: .L
        )) { guard case EncoderError.uncorrectData(_) = $0 else { return XCTFail() } }

        XCTAssertThrowsError(try encoder_.validateData(
            "afs32\"fds", correctionLevel: .L
        )) { guard case EncoderError.uncorrectData(_) = $0 else { return XCTFail() } }
    }

    func testValidateDataWithDifferentDataSizes() {
        XCTAssertThrowsError(try encoder_.validateData(
            "", correctionLevel: .L
        )) { guard case EncoderError.dataIsEmpty = $0 else { return XCTFail() } }

        var text = String(repeating: "0", count: 4296)
        XCTAssertNoThrow(try encoder_.validateData(
            text, correctionLevel: .L
        ))
        text = String(repeating: "0", count: 4297)
        XCTAssertThrowsError(try encoder_.validateData(
            text, correctionLevel: .L
        )) { guard case EncoderError.tooMuchData = $0 else { return XCTFail() } }

        text = String(repeating: "0", count: 3391)
        XCTAssertNoThrow(try encoder_.validateData(
            text, correctionLevel: .M
        ))
        text = String(repeating: "0", count: 3392)
        XCTAssertThrowsError(try encoder_.validateData(
            text, correctionLevel: .M
        )) { guard case EncoderError.tooMuchData = $0 else { return XCTFail() } }

        text = String(repeating: "0", count: 2420)
        XCTAssertNoThrow(try encoder_.validateData(
            text, correctionLevel: .Q
        ))
        text = String(repeating: "0", count: 2421)
        XCTAssertThrowsError(try encoder_.validateData(
            text, correctionLevel: .Q
        )) { guard case EncoderError.tooMuchData = $0 else { return XCTFail() } }

        text = String(repeating: "0", count: 1852)
        XCTAssertNoThrow(try encoder_.validateData(
            text, correctionLevel: .H
        ))
        text = String(repeating: "0", count: 1853)
        XCTAssertThrowsError(try encoder_.validateData(
            text, correctionLevel: .H
        )) { guard case EncoderError.tooMuchData = $0 else { return XCTFail() } }
    }

    func testGenerateQRBits() {
        var encoded = encoder_.generateQRBits(for: "HELLO")
        XCTAssertEqual("0110000101101111000110011000", encoded)
        encoded = encoder_.generateQRBits(for: "hello")
        XCTAssertEqual("0110000101101111000110011000", encoded)

        encoded = encoder_.generateQRBits(for: "abc123$%")
        XCTAssertEqual("00111001101010000111010000101110111010100111", encoded)

        encoded = encoder_.generateQRBits(for: "abc123$%:")
        XCTAssertEqual("00111001101010000111010000101110111010100111101100", encoded)

        encoded = encoder_.generateQRBits(for: "")
        XCTAssertEqual("", encoded)
    }
}
