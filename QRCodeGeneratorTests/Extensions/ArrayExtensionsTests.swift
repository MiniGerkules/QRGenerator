//
//  ArrayExtensionsTests.swift
//  QRCodeGeneratorTests
//
//  Created by Евгений Кацер on 16.09.2023.
//

import XCTest
@testable import QRCodeGenerator

class ArrayExtensionsTests: XCTestCase {
    func testShiftLeftOnEmptyArray() {
        var array = [Int]()

        array.shiftLeft(by: 5, filler: 1)
        array.shiftLeft(by: -5, filler: 2)

        XCTAssert(array.isEmpty)
    }

    func testShiftLeftWhenShiftNumMoreThanSize() {
        var array = [1, 2, 3, 4, 5]

        array.shiftLeft(by: 10, filler: 1)
        array.shiftLeft(by: -10, filler: 2)

        XCTAssertEqual([1, 2, 3, 4, 5], array)
    }

    func testShiftLeftNormalConditions() {
        var array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

        array.shiftLeft(by: -1, filler: 10)
        XCTAssertEqual([10, 0, 1, 2, 3, 4, 5, 6, 7, 8], array)

        array.shiftLeft(by: 1, filler: 9)
        XCTAssertEqual([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], array)

        array.shiftLeft(by: 4, filler: 15)
        XCTAssertEqual([4, 5, 6, 7, 8, 9, 15, 15, 15, 15], array)

        array.shiftLeft(by: -2, filler: 13)
        XCTAssertEqual([13, 13, 4, 5, 6, 7, 8, 9, 15, 15], array)

        array.shiftLeft(by: -2, filler: -3)
        XCTAssertEqual([-3, -3, 13, 13, 4, 5, 6, 7, 8, 9], array)

        array.shiftLeft(by: 9, filler: 1)
        XCTAssertEqual([9, 1, 1, 1, 1, 1, 1, 1, 1, 1], array)

        array.shiftLeft(by: -9, filler: 2)
        XCTAssertEqual([2, 2, 2, 2, 2, 2, 2, 2, 2, 9], array)

        array.shiftLeft(by: 10, filler: 7)
        XCTAssertEqual([7, 7, 7, 7, 7, 7, 7, 7, 7, 7], array)

        array.shiftLeft(by: -10, filler: 17)
        XCTAssertEqual([17, 17, 17, 17, 17, 17, 17, 17, 17, 17], array)
    }

    func testMergeOnEmptyArray() {
        let arr = [[UInt8]]()
        var qrData = QRData()

        arr.merge(to: &qrData)

        XCTAssert(qrData.isEmpty)
    }

    func testMergeWithSavindDataInInoutArg() {
        var qrData: QRData = [1, 2, 3, 4, 5]

        [[UInt8]]().merge(to: &qrData)
        XCTAssertEqual([1, 2, 3, 4, 5], qrData)

        [[UInt8(10)], [20], [30]].merge(to: &qrData)
        XCTAssertEqual([1, 2, 3, 4, 5, 10, 20, 30], qrData)
    }

    func testMergeNormalConditions() {
        var qrData: QRData = []
        [[UInt8(1)], [2], [3], [4], [5]].merge(to: &qrData)
        XCTAssertEqual([1, 2, 3, 4, 5], qrData)

        qrData = []
        [[UInt8(1)], [2], [3, 5], [4, 6]].merge(to: &qrData) // usage in project
        XCTAssertEqual([1, 2, 3, 4, 5, 6], qrData)

        qrData = []
        [[UInt8(1), 5, 8], [2], [3, 6], [4, 7]].merge(to: &qrData)
        XCTAssertEqual([1, 2, 3, 4, 5, 6, 7, 8], qrData)

        qrData = []
        [[UInt8(1), 4, 7], [], [2, 5], [3, 6, 8]].merge(to: &qrData)
        XCTAssertEqual([1, 2, 3, 4, 5, 6, 7, 8], qrData)

        qrData = []
        [[UInt8](), [], [1, 2, 3, 4, 5]].merge(to: &qrData)
        XCTAssertEqual([1, 2, 3, 4, 5], qrData)
    }
}
