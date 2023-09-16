//
//  QRCodeGeneratorTests.swift
//  QRCodeGeneratorTests
//
//  Created by Евгений Кацер on 15.09.2023.
//

import XCTest
@testable import QRCodeGenerator

final class StringExensionsTests: XCTestCase {
    func testAlignWithEmptyStr() {
        var testStr = ""

        testStr.align(to: 10, with: "0")
        testStr.align(to: 5, with: "1")
        testStr.align(to: 3, with: "2")
        testStr.align(to: 5, with: "5")

        XCTAssertEqual("", testStr)
    }

    func testAlignWithNonEmptyStr() {
        var testStr = "6"

        testStr.align(to: 10, with: "0")
        testStr.align(to: 5, with: "1")
        testStr.align(to: 3, with: "2")
        testStr.align(to: 5, with: "5")

        XCTAssertEqual("600000000022555", testStr)
    }

    func testSplitWithEmptyStr() {
        let testStr = ""

        var splitted = testStr.split(by: 5)
        XCTAssertNotNil(splitted)
        XCTAssertEqual(splitted?.count, 1)
        XCTAssertEqual(splitted?.first, "")

        splitted = testStr.split(by: 1)
        XCTAssertNotNil(splitted)
        XCTAssertEqual(splitted?.count, 1)
        XCTAssertEqual(splitted?.first, "")

        splitted = testStr.split(by: -5)
        XCTAssertNil(splitted)
    }

    func testSplitWithNonEmptyStr() {
        let testStr = "0123456789"

        var splitted = testStr.split(by: 5)
        XCTAssertNotNil(splitted)
        XCTAssertEqual(splitted, ["01234", "56789"])

        splitted = testStr.split(by: 3)
        XCTAssertNotNil(splitted)
        XCTAssertEqual(splitted, ["012", "345", "678", "9"])

        splitted = testStr.split(by: 1)
        XCTAssertNotNil(splitted)
        XCTAssertEqual(splitted, ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])

        splitted = testStr.split(by: -5)
        XCTAssertNil(splitted)
    }
}
