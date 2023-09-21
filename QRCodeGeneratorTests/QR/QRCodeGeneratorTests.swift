//
//  QRCodeGeneratorTests.swift
//  QRCodeGeneratorTests
//
//  Created by Евгений Кацер on 19.09.2023.
//

import XCTest
@testable import QRCodeGenerator

final class QRCodeGeneratorTests: XCTestCase {
    let b = QRCode.Module.withData, w = QRCode.Module.withoutData

    func testGenerateQRCodeLettersNumsLevelQ() {
        let qrMustBe: [[QRCode.Module]] = [
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],

            [w, w, w, w,    b, b, b, b, b, b, b, w, w, w, w, b, w, w, b, b, b, b, b, b, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, b, b, w, w, b, w, b, w, w, w, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, w, b, w, b, b, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, b, b, b, b, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, b, w, b, w, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, w, b, w, w, b, w, b, w, w, w, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, b, w, b, w, b, w, b, b, b, b, b, b, b,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, b, b, w, b, b, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, b, w, b, b, b, b, w, b, b, w, w, b, b, b, w, b, b, w, b, w,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, b, w, b, w, w, w, w, b, b, b, b, w, b, b, b, w,    w, w, w, w],
            [w, w, w, w,    w, w, b, w, b, w, b, b, w, w, w, b, w, w, b, b, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, w, b, w, w, w, b, w, b, b, w, w, w, b, b, w, w, w,    w, w, w, w],
            [w, w, w, w,    b, b, w, b, b, b, b, b, b, b, b, w, b, b, b, w, b, b, b, b, b,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, b, w, w, w, b, w, w, b, w, b, w, w, w,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, w, b, b, w, w, b, b, w, w, b, b, b, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, b, w, b, w, w, b, w, w, b, w, b, b, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, b, w, b, w, w, b, w, w, w, b, b, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, w, b, b, b, w, w, w, b, w, b, w, w,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, w, b, w, w, w, w, b, w, w, w, w, b, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, b, b, b, w, w, b, b, b, w, w, b, b, w,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, w, b, w, b, w, w, w, w, w, w, w, b, w,    w, w, w, w],

            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
        ]

        let correctionLevel = QRConstants.CorrectionLevel.Q
        let encoder = LettersAndNumsQREncoder()
        let (qrData, version) = try! encoder.generateQRData("HELLO WORLD", with: correctionLevel)
        let qrCode = QRCodeGenerator.generateQRCode(qrData: qrData,
                                                    correctionLevel: correctionLevel,
                                                    version: version)

        XCTAssertEqual(qrMustBe, qrCode.qrData)
    }

    func testGenerateQRCodeNumsLevelQ() {
        let qrMustBe: [[QRCode.Module]] = [
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],

            [w, w, w, w,    b, b, b, b, b, b, b, w, b, w, b, w, b, w, b, b, b, b, b, b, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, b, b, b, b, b, w, b, w, w, w, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, w, b, b, w, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, b, w, b, b, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, b, b, w, w, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, w, b, w, b, w, w, b, w, w, w, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, b, w, b, w, b, w, b, b, b, b, b, b, b,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, b, w, b, b, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, b, b, w, b, w, b, b, w, b, w, b, w, w, b, w, b, b, b, b, b,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, w, b, w, b, w, b, b, w, b, b, w, b, w, b, w, w, b,    w, w, w, w],
            [w, w, w, w,    w, w, w, b, b, b, b, b, b, b, b, w, b, b, b, b, w, b, w, w, b,    w, w, w, w],
            [w, w, w, w,    w, b, w, b, b, w, w, w, b, w, w, w, b, b, w, b, b, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    b, w, w, b, w, b, b, b, w, w, b, b, w, b, b, b, w, w, w, b, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, b, w, b, w, w, w, b, w, w, w, b, b, w,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, b, w, b, b, b, w, w, w, b, w, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, w, w, b, b, b, w, b, w, w, w, w, b, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, w, b, b, w, w, b, w, b, w, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, w, b, b, b, w, b, w, b, w, b, b, b, w,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, b, w, b, w, b, b, b, w, w, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, b, w, b, b, b, b, w, b, b, b, w, w, w,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, w, b, b, b, w, b, b, b, w, w, b, w, b,    w, w, w, w],

            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
        ]

        let correctionLevel = QRConstants.CorrectionLevel.Q
        let encoder = NumsQREncoder()
        let (qrData, version) = try! encoder.generateQRData("21121973", with: correctionLevel)
        let qrCode = QRCodeGenerator.generateQRCode(qrData: qrData,
                                                    correctionLevel: correctionLevel,
                                                    version: version)

        XCTAssertEqual(qrMustBe, qrCode.qrData)
    }

    func testGenerateQRCodeBytesLevelQ() {
        let qrMustBe: [[QRCode.Module]] = [
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],

            [w, w, w, w,    b, b, b, b, b, b, b, w, w, b, w, w, b, w, w, b, b, w, b, b, b, b, b, b, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, b, w, b, w, w, w, w, w, b, w, b, w, w, w, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, w, b, b, w, b, w, w, b, b, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, w, b, b, b, w, w, w, b, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, w, w, w, w, w, b, b, b, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, w, b, w, w, w, w, w, b, b, w, b, w, w, w, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, b, w, b, w, b, w, b, w, b, w, b, b, b, b, b, b, b,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, b, w, w, b, w, b, w, b, b, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, b, w, b, b, b, b, w, b, w, w, b, b, b, w, w, b, b, b, w, b, b, w, b, w,    w, w, w, w],
            [w, w, w, w,    w, b, w, w, w, w, w, w, w, b, b, b, w, b, w, w, b, w, w, w, b, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, w, b, b, b, b, b, w, b, b, b, b, b, b, w, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, b, w, b, w, b, w, b, w, b, b, b, w, b, w, w, b, b, b, b, w, b, b, w, w,    w, w, w, w],
            [w, w, w, w,    w, b, w, w, w, b, b, b, b, b, b, w, w, b, w, b, b, w, b, b, w, b, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, b, w, w, w, w, w, b, b, b, b, w, b, b, b, b, w, w, w, w, b, b, w, b, w,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, b, w, w, b, b, b, w, b, b, b, w, b, b, w, b, w, b, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, w, b, b, w, w, b, b, w, b, w, b, b, w, w, w, w, w, w, b, b, b, w,    w, w, w, w],
            [w, w, w, w,    b, w, b, w, w, w, b, w, w, b, w, b, w, w, w, b, b, b, b, b, b, w, b, b, b,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, b, w, w, b, b, w, b, b, b, w, w, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, w, w, b, b, w, w, w, w, b, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, b, w, w, b, b, b, w, b, b, w, w, w, b, w, w, b, w,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, w, w, w, b, w, w, b, b, b, b, b, b, b, w, b, w,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, b, w, b, b, b, w, b, w, b, b, w, w, w, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, w, w, b, b, w, w, w, b, w, b, w, b, b, b, w, b, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, b, b, w, b, w, b, w, b, w, w, b, w, w, b, b, b, b,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, w, w, w, w, b, b, w, w, b, w, b, w, b, w, w, w, b,    w, w, w, w],

            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
        ]

        let correctionLevel = QRConstants.CorrectionLevel.Q
        let encoder = BytesQREncoder()
        let (qrData, version) = try! encoder.generateQRData("Swift the best!", with: correctionLevel)
        let qrCode = QRCodeGenerator.generateQRCode(qrData: qrData,
                                                    correctionLevel: correctionLevel,
                                                    version: version)

        XCTAssertEqual(qrMustBe, qrCode.qrData)
    }

    func testGenerateQRCodeBytesLevelH() {
        let qrMustBe: [[QRCode.Module]] = [
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],

            [w, w, w, w,    b, b, b, b, b, b, b, w, w, w, b, w, w, b, w, w, b, b, b, b, w, w, b, b, b, b, b, b, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, b, w, w, w, b, w, w, b, b, w, b, b, w, w, b, w, w, w, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, b, w, b, w, w, b, w, w, b, w, w, w, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, b, b, w, b, w, w, b, b, b, w, b, w, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, b, b, b, b, b, b, b, w, b, b, w, w, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, b, b, b, w, b, w, w, b, b, w, w, w, b, w, b, w, w, w, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, b, w, b, w, b, w, b, w, b, w, b, w, b, w, b, b, b, b, b, b, b,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, b, b, b, w, b, w, b, b, w, b, b, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, b, w, w, b, b, b, b, b, w, b, b, b, b, b, b, b, b, b, w, b, w, b, b, b, b, b, w,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, w, w, b, w, w, w, w, w, b, w, b, b, b, w, w, b, b, b, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, b, w, b, b, w, w, w, b, b, w, w, w, b, b, b, b, w, b, b, w, w, b, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, b, w, w, b, w, w, w, w, b, w, b, b, w, b, w, b, b, w, w, w, b, b, w, w, b, w, b, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, b, w, b, w, b, w, b, b, b, b, w, w, b, b, b, b, b, b, b, w, w, b, w, w, b,    w, w, w, w],
            [w, w, w, w,    w, b, b, b, b, b, w, b, b, b, w, w, w, b, b, b, w, w, b, b, b, w, b, b, w, w, b, b, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, b, b, w, b, b, b, b, w, w, b, b, b, b, b, b, w, b, w, w, b, w, b, w, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, b, w, b, w, b, w, w, b, w, w, b, b, b, w, b, b, b, w, w, w, w, w, w, b, b, w, w, w,    w, w, w, w],
            [w, w, w, w,    b, b, w, w, w, b, b, b, w, b, w, w, b, w, w, w, b, w, w, w, b, b, b, b, w, w, w, b, b,    w, w, w, w],
            [w, w, w, w,    w, b, w, w, b, b, w, b, w, w, b, b, w, b, w, b, w, w, b, w, b, w, b, b, w, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, w, w, w, b, b, w, b, w, b, b, w, w, b, b, b, w, b, w, w, b, b,    w, w, w, w],
            [w, w, w, w,    w, w, w, b, w, b, w, b, w, b, b, w, b, b, b, b, b, b, w, b, b, w, w, b, w, b, w, w, w,    w, w, w, w],
            [w, w, w, w,    b, b, w, w, w, w, b, b, b, b, w, b, w, b, w, b, w, b, w, w, b, b, b, b, b, b, w, w, b,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, b, b, w, b, b, w, w, b, w, w, w, w, b, w, w, w, b, b, w, b, b,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, b, w, w, w, w, w, w, w, w, w, b, w, b, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, b, b, w, w, b, w, w, w, b, w, w, b, b, w, w, w, b, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, w, b, b, w, b, b, w, b, b, b, b, b, b, b, b, b, b, b, w, b, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, w, b, b, b, w, w, b, w, w, b, b, w, b, b, w, w, b, w, b, b, w,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, w, b, w, b, b, b, b, b, b, w, w, w, b, w, w, b, b, w, b, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, w, w, w, b, w, w, w, b, w, b, b, w, w, b, w, w, w, b, w, w, w,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, w, w, b, w, w, b, w, b, b, w, w, b, b, w, b, b, b, b, w, w, b,    w, w, w, w],

            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
        ]

        let correctionLevel = QRConstants.CorrectionLevel.H
        let encoder = BytesQREncoder()
        let (qrData, version) = try! encoder.generateQRData("%It is nice project%", with: correctionLevel)
        let qrCode = QRCodeGenerator.generateQRCode(qrData: qrData,
                                                    correctionLevel: correctionLevel,
                                                    version: version)

        XCTAssertEqual(qrMustBe, qrCode.qrData)
    }

    func testGenerateQRCodeLettersAndNumsLevelM() {
        let qrMustBe: [[QRCode.Module]] = [
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],

            [w, w, w, w,    b, b, b, b, b, b, b, w, w, w, b, w, b, b, w, w, b, w, b, b, b, b, b, b, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, b, w, w, b, w, w, b, b, b, w, b, w, w, w, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, w, b, b, b, w, b, b, w, b, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, w, w, b, w, w, b, b, b, w, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, w, w, b, b, w, b, w, w, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, w, b, w, w, w, b, w, w, w, w, b, w, w, w, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, b, w, b, w, b, w, b, w, b, w, b, b, b, b, b, b, b,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, b, b, b, w, b, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    b, w, b, w, b, w, b, w, w, w, b, b, w, w, b, b, b, w, w, w, b, w, w, b, w,    w, w, w, w],
            [w, w, w, w,    b, w, w, b, b, b, w, b, b, w, w, w, b, w, b, b, w, w, w, b, b, b, w, b, w,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, b, b, b, w, b, w, b, w, w, b, w, w, b, w, w, b, b, b, b, b, w,    w, w, w, w],
            [w, w, w, w,    b, b, w, w, b, b, w, w, w, b, b, b, w, w, w, b, w, b, b, b, b, b, w, b, w,    w, w, w, w],
            [w, w, w, w,    w, w, b, b, w, b, b, w, b, b, b, b, b, w, w, w, b, w, w, b, w, b, b, b, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, b, w, w, w, b, b, w, b, b, b, w, w, b, w, w, w, b, w, w, b, w,    w, w, w, w],
            [w, w, w, w,    b, w, b, w, w, b, b, w, b, w, b, b, b, w, b, b, b, b, w, b, w, w, b, b, b,    w, w, w, w],
            [w, w, w, w,    w, b, w, w, w, w, w, b, w, b, w, w, b, b, b, w, b, b, b, b, b, b, w, b, w,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, w, b, b, b, w, b, w, b, w, w, b, w, b, b, b, b, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, b, w, b, b, w, w, b, b, b, w, w, w, b, w, b, w, w,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, w, w, w, w, w, b, w, b, b, w, b, w, b, w, w, b, w,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, w, w, b, b, w, w, w, b, b, w, w, w, b, b, b, b, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, w, b, w, b, w, w, b, b, b, b, b, b, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, w, b, w, b, b, b, w, w, w, w, b, w, b, w, b, b, w,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, w, w, b, b, w, b, w, w, b, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, w, w, b, w, b, b, b, b, w, b, b, b, b, b, w, b, b,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, b, b, b, b, w, w, b, w, w, b, w, w, w, w, w, w, b,    w, w, w, w],

            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
        ]

        let correctionLevel = QRConstants.CorrectionLevel.M
        let encoder = LettersAndNumsQREncoder()
        let (qrData, version) = try! encoder.generateQRData("SO COOL THAT IT WORKS", with: correctionLevel)
        let qrCode = QRCodeGenerator.generateQRCode(qrData: qrData,
                                                    correctionLevel: correctionLevel,
                                                    version: version)

        XCTAssertEqual(qrMustBe, qrCode.qrData)
    }

    func testGenerateQRCodeNumsLevelL() {
        let qrMustBe: [[QRCode.Module]] = [
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],

            [w, w, w, w,    b, b, b, b, b, b, b, w, b, b, w, w, b, w, b, b, b, b, b, b, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, w, b, w, w, b, w, b, w, w, w, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, w, b, w, b, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, w, w, b, w, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, b, b, w, w, w, b, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, w, w, w, w, w, w, b, w, w, w, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, b, w, b, w, b, w, b, b, b, b, b, b, b,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, b, b, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, w, w, b, w, b, w, b, w, w, b, w, w, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, w, w, w, w, b, w, b, w, b, w, w, b, w, b, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, b, w, b, w, w, b, w, b, w, b, w, b, b, b, b, b, b, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, w, w, b, b, b, w, b, b, w, w, w, b, w, w, w,    w, w, w, w],
            [w, w, w, w,    b, w, w, b, b, w, b, b, w, w, b, b, w, b, w, w, b, w, w, b, b,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, b, b, b, w, w, b, w, b, w, b, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, w, b, w, w, w, b, b, w, b, w, w, b, w,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, w, w, w, b, b, b, b, w, w, w, w, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, w, b, w, b, w, w, b, w, w, w, b, w, b,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, w, b, w, w, b, w, w, b, w, b, b, w,    w, w, w, w],
            [w, w, w, w,    b, w, b, b, b, w, b, w, b, w, w, b, w, b, w, w, b, w, b, w, w,    w, w, w, w],
            [w, w, w, w,    b, w, w, w, w, w, b, w, b, b, w, b, b, w, b, w, b, b, w, b, b,    w, w, w, w],
            [w, w, w, w,    b, b, b, b, b, b, b, w, b, b, w, b, b, w, w, b, w, w, w, b, w,    w, w, w, w],

            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
            [w, w, w, w,    w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w,    w, w, w, w],
        ]

        let correctionLevel = QRConstants.CorrectionLevel.L
        let encoder = NumsQREncoder()
        let (qrData, version) = try! encoder.generateQRData("21092023", with: correctionLevel)
        let qrCode = QRCodeGenerator.generateQRCode(qrData: qrData,
                                                    correctionLevel: correctionLevel,
                                                    version: version)

        XCTAssertEqual(qrMustBe, qrCode.qrData)
    }
}
