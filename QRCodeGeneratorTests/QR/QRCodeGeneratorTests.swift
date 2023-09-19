//
//  QRCodeGeneratorTests.swift
//  QRCodeGeneratorTests
//
//  Created by Евгений Кацер on 19.09.2023.
//

import XCTest
@testable import QRCodeGenerator

final class QRCodeGeneratorTests: XCTestCase {
    func testGenerateQRCode() {
        let b = QRCode.Module.withData, w = QRCode.Module.withoutData

        let qrMustBe: [[QRCode.Module]] = [
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],

            [w, w, w, w,    b, b, b, b, b, b, b, w, w, b, w, b, b, w, b, b, b, b, b, b, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, w, w, w, w, w, w, b, w, w, w, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, b, b, b, b, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, b, b, w, w, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, b, b, b, b, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, b, b, w, w, b, w, b, w, w, w, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, b, w, b, w, b, w, b, b, b, b, b, b, b,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, b, b, w, b, b, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, b, b, w, w, w, w, w, b, w, b, b, b, b, b, w, w,    w, w, w, w],
            [w, w, w, w,    w, b, w, w, w, w, w, w, b, b, w, w, b, w, w, b, w, b, w, w, b,    w, w, w, w],
            [w, w, w, w,    w, b, b, b, w, w, b, b, b, b, b, b, w, b, w, w, b, b, w, w, b,    w, w, w, w],
            [w, w, w, w,    w, w, b, b, b, w, w, b, b, w, w, w, w, w, w, b, b, w, b, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, b, b, w, b, b, b, b, w, b, b, w, b, w, w, b, w, b, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, b, w, b, b, b, b, b, w, w, b, w, b, w,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, w, b, b, w, b, w, b, b, w, w, w, b, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, b, b, b, b, b, b, b, w, w, b, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, b, b, w, b, w, w, b, w, w, b, w, w,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, b, w, w, b, w, w, b, w, w, b, w, w,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, b, w, b, w, b, w, w, b, b, b, w, w,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, w, b, w, w, w, w, w, b, b, w, b, w, w,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, b, w, b, b, w, b, w, w, b, b, b, b, w,    w, w, w, w],

            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
        ]

        let correctionLevel = QRConstants.CorrectionLevel.M
        let (qrData, version) = try! BytesQREncoder().generateQRData("Я", with: correctionLevel)
        let qrCode = QRCodeGenerator.generateQRCode(qrData: qrData,
                                                    correctionLevel: correctionLevel,
                                                    version: version)

        XCTAssertEqual(qrMustBe, qrCode.qrData)
    }
}
