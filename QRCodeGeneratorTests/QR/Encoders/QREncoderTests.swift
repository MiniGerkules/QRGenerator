//
//  QREncoderTests.swift
//  QRCodeGeneratorTests
//
//  Created by Евгений Кацер on 17.09.2023.
//

import XCTest
@testable import QRCodeGenerator

final class QREncoderTests: XCTestCase {
    private let encoder_ = NumsQREncoder()

    func testGenerateQRData() {
        let arrMustBe: QRData = [16, 36, 123, 114, 49, 80, 236, 17, 236, 17, 236,   // Data
                                 17, 236, 17, 236, 17, 236, 17, 236,                // Data
                                 124, 242, 180, 34, 68, 5, 233]                     // Correction

        guard let result = try? encoder_.generateQRData("123456789", with: .L) else {
            XCTFail("Must be not optional!")
            return
        }

        XCTAssertEqual(QRVersion(version: 1)!, result.1)

        XCTAssertEqual(arrMustBe.count, result.0.count)
        XCTAssertEqual(arrMustBe, result.0)
    }
}
