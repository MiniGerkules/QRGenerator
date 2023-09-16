//
//  IntExtensionsTests.swift
//  QRCodeGeneratorTests
//
//  Created by Евгений Кацер on 16.09.2023.
//

import XCTest
@testable import QRCodeGenerator

final class IntExtensionsTests: XCTestCase {
    func testToBinStringForUnsigned() {
        var value: UInt8 = 0
        XCTAssertEqual("00000000", value.toBinString())

        value = 1
        XCTAssertEqual("00000001", value.toBinString())

        value = 0x0A
        XCTAssertEqual("00001010", value.toBinString())

        value = 0x0F
        XCTAssertEqual("00001111", value.toBinString())

        value = 0xA0
        XCTAssertEqual("10100000", value.toBinString())

        value = 0xF0
        XCTAssertEqual("11110000", value.toBinString())

        value = 0xAA
        XCTAssertEqual("10101010", value.toBinString())

        value = 0xFF
        XCTAssertEqual("11111111", value.toBinString())
    }

    func testToBinStringForSigned() {
        var value: Int8 = 0
        XCTAssertEqual("00000000", value.toBinString())

        value = 1
        XCTAssertEqual("00000001", value.toBinString())

        value = 0x0A
        XCTAssertEqual("00001010", value.toBinString())

        value = 0x0F
        XCTAssertEqual("00001111", value.toBinString())

        value = 0x7F
        XCTAssertEqual("01111111", value.toBinString())

        value = -1
        XCTAssertEqual("11111111", value.toBinString())
    }
}
