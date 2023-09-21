//
//  QREncoderTests.swift
//  QRCodeGeneratorTests
//
//  Created by Евгений Кацер on 17.09.2023.
//

import XCTest
@testable import QRCodeGenerator

final class QREncoderTests: XCTestCase {
    func testGenerateNumsQRData() {
        let arrMustBe: QRData = [16, 36, 123, 114, 49, 80, 236, 17, 236, 17, 236,   // Data
                                 17, 236, 17, 236, 17, 236, 17, 236,                // Data
                                 124, 242, 180, 34, 68, 5, 233]                     // Correction

        let encoder = NumsQREncoder()
        guard let result = try? encoder.generateQRData("123456789", with: .L) else {
            XCTFail("Must be not optional!")
            return
        }

        XCTAssertEqual(QRVersion(version: 1)!, result.1)

        XCTAssertEqual(arrMustBe.count, result.0.count)
        XCTAssertEqual(arrMustBe, result.0)
    }

    func testGenerateLettersAndNumsQRData() {
        let arrMustBe: QRData = [32, 91, 11, 120, 209, 114, 220, 77, 67, 64, 236,   // Data
                                 17, 236, 17, 236, 17,                              // Data
                                 196, 35, 39, 119, 235, 215, 231, 226, 93, 23]      // Correction

        let encoder = LettersAndNumsQREncoder()
        guard let result = try? encoder.generateQRData("Hello world", with: .M) else {
            XCTFail("Must be not optional!")
            return
        }

        XCTAssertEqual(QRVersion(version: 1)!, result.1)

        XCTAssertEqual(arrMustBe.count, result.0.count)
        XCTAssertEqual(arrMustBe, result.0)
    }
}
