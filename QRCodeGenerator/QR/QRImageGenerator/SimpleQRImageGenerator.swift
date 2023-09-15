//
//  SimpleQRImageGenerator.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 10.09.2023.
//

import UIKit.UIImage

struct SimpleQRImageGenerator: QRImageGenerator {
    let screenSideMinSize: CGFloat

    func generateQRImage(qrData: QRData, correctionLevel: QRConstants.CorrectionLevel,
                         version: QRVersion) -> UIImage {
        let sideSizeInModules = QRConstants.getQRCodeSideSize(version: version)
        var qrCode = QRCode(qrCodeSideLen: sideSizeInModules)

        addSearchPatterns_(qrCode: &qrCode)
        addSyncLines_(qrCode: &qrCode)
        addLevelingPatterns_(qrCode: &qrCode, version: version)
        addQRCodeVersion_(qrCode: &qrCode, version: version)

        addCorrectionLevelMaskAndData(qrCode: &qrCode, qrData: qrData,
                                      correctionLevel: correctionLevel)

        return render_(qrCode: qrCode)
    }
}

//MARK: - Types to make work more convenient
private extension SimpleQRImageGenerator {
    enum Color {
        case black, white
        case notSetted

        static prefix func !(color: Color) -> Color {
            switch color {
            case .black: return .white
            case .white: return .black
                //TODO: replace with fatal error
            case .notSetted: return .notSetted //fatalError("Color must be setted to be inverted!")
            }
        }

        func toUIColor() -> UIColor {
            switch self {
            case .black: return UIColor.black
            case .white: return UIColor.white
                //TODO: replace with with fatalError
            case .notSetted: return UIColor.red//fatalError("All qr modules must have value!")
            }
        }
    }

    struct Square {
        let x, y: Int
        let side: Int
    }

    class QRCode {
        static let borderLen = QRConstants.qrCodeBorderLen

        private(set) var qrData: [[Color]]

        subscript(y: Int, x: Int) -> Color {
            get {
                return qrData[y + Self.borderLen][x + Self.borderLen]
            }
            set {
                qrData[y + Self.borderLen][x + Self.borderLen] = newValue
            }
        }

        var sideLen: Int { qrData.count - 2*Self.borderLen }
        var renderSideLen: Int { qrData.count }

        init(qrCodeSideLen: Int) {
            let fullSideLen = qrCodeSideLen + 2*Self.borderLen

            qrData = Array(
                repeating: Array(repeating: Color.notSetted, count: fullSideLen),
                count: fullSideLen
            )

            for along in 0..<renderSideLen {
                for border in 0..<Self.borderLen {
                    qrData[along][border] = Color.white // Left border
                    qrData[along][renderSideLen - border - 1] = Color.white // Right border

                    qrData[border][along] = Color.white // Upper border
                    qrData[renderSideLen - border - 1][along] = Color.white // Lower border
                }
            }
        }
    }

    typealias Position = (Int, Int)
    typealias Positions = [Position]
}

//MARK: - Methods to fill QR code with data
private extension SimpleQRImageGenerator {
    func addSearchPatterns_(qrCode: inout QRCode) {
        let searchingSideLen = QRConstants.searchingPatternSideLen

        // Left up square
        addQRSquareWithBorder_(qrCode: &qrCode,
                               startX: 0, startY: 0,
                               sideLen: searchingSideLen)

        // Left down square
        addQRSquareWithBorder_(qrCode: &qrCode,
                               startX: 0, startY: qrCode.sideLen - searchingSideLen,
                               sideLen: searchingSideLen)

        // Right up square
        addQRSquareWithBorder_(qrCode: &qrCode,
                               startX: qrCode.sideLen - searchingSideLen, startY: 0,
                               sideLen: searchingSideLen)
    }

    func addLevelingPatterns_(qrCode: inout QRCode, version: QRVersion) {
        let points = QRConstants.getCentersOfLevelingPatterns(version: version)
        let sideLen = QRConstants.levelingPatternSideLen

        for (x, y) in points {
            let trueX = x - sideLen/2, trueY = y - sideLen/2
            addQRSquare_(qrCode: &qrCode, startX: trueX, startY: trueY, sideLen: sideLen)
        }
    }

    func addSyncLines_(qrCode: inout QRCode) {
        let start = QRConstants.searchingPatternSideLen + 1
        let end = qrCode.sideLen - start

        let level = QRConstants.searchingPatternSideLen - 1

        for elem in stride(from: start, to: end, by: 2) {
            qrCode[level, elem] = Color.black
            qrCode[elem, level] = Color.black
        }

        for elem in stride(from: start + 1, to: end, by: 2) {
            qrCode[level, elem] = Color.white
            qrCode[elem, level] = Color.white
        }
    }

    func addQRCodeVersion_(qrCode: inout QRCode, version: QRVersion) {
        guard let versionID = QRConstants.qrVersionsID[version] else { return }

        let colors = toColors_(str: versionID)
        guard colors.count == 18 else { return }

        let numOfRows = 3 // Number of rows to encode version of QR
        let startY = qrCode.sideLen - QRConstants.searchingPatternSideLen - numOfRows - 1
        let startX = 0

        for row in 0..<numOfRows {
            let start = row * 6, end = start + 6

            for (column, color) in colors[start..<end].enumerated() {
                qrCode[startY + row, startX + column] = color
                qrCode[startX + column, startY + row] = color
            }
        }
    }
}

//MARK: - Methods to add correction level, mask and data to QR code
private extension SimpleQRImageGenerator {
    private func addCorrectionLevelMaskAndData(qrCode: inout QRCode,
                                               qrData: QRData,
                                               correctionLevel: QRConstants.CorrectionLevel) {
        let positions = generatePositions_(qrCode: qrCode)

        let maskID = QRConstants.masks.keys.randomElement()!
        let maskFunc = QRConstants.masks[maskID]!

        // Reserve pixels to not color them with data
        addCorrectionLevelAndMask_(qrCode: &qrCode,
                                   colors: [Color](repeating: Color.notSetted, count: 15))

        addQRData_(qrCode: &qrCode, qrData: qrData, positions: positions,
                   maskFunc: maskFunc)

        let colors = toColors_(
            str: QRConstants.getCodeOfMaskAndCorLevel(
                for: correctionLevel, and: maskID
            )!
        )
        addCorrectionLevelAndMask_(qrCode: &qrCode, colors: colors)

        //TODO: Add choosing the best mask
//        for (maskID, maskFunc) in QRConstants.masks {
//            addQRData_(qrCode: &qrCode, qrData: qrData, positions: positions,
//                       maskFunc: maskFunc)
//            addCorrectionLevelAndMask_(qrCode: &qrCode, correctionLevel: correctionLevel,
//                                       maskID: maskID)
//        }
    }

    func addCorrectionLevelAndMask_(qrCode: inout QRCode, colors: [Color]) {
        guard colors.count == 15 else {
            fatalError("The correction level and mask code must consist of 15 colors!")
        }

        let level = QRConstants.searchingPatternSideLen + 1

        // Upper left corner
        for (ind, color) in colors.prefix(7).enumerated() {
            let bias = ind >= 6 ? 1 : 0
            qrCode[level, ind + bias] = color // Down border
        }

        for (ind, color) in colors.suffix(8).reversed().enumerated() {
            let bias = ind >= 6 ? 1 : 0
            qrCode[ind + bias, level] = color // Left border
        }

        // Lower left corner
        for (ind, color) in colors.prefix(7).enumerated() {
            qrCode[qrCode.sideLen - 1 - ind, level] = color
        }
        qrCode[qrCode.sideLen - 1 - 7, level] = Color.black // Must always be black

        // Upper right corner
        for (ind, color) in colors.suffix(8).reversed().enumerated() {
            qrCode[level, qrCode.sideLen - 1 - ind] = color
        }
    }

    func addQRData_(qrCode: inout QRCode, qrData: QRData, positions: Positions,
                    maskFunc: QRConstants.MaskFunction) {
        var cur = positions.startIndex

        for num in qrData {
            let colors = toColors_(str: num.toBinString())

            for color in colors {
                let (x, y) = positions[cur]
                qrCode[y, x] = maskFunc(x, y) != 0 ? color : !color

                cur = positions.index(after: cur)
            }
        }

        while cur < positions.endIndex {
            let (x, y) = positions[cur]
            qrCode[y, x] = Color.white

            cur = positions.index(after: cur)
        }
    }
}

//MARK: - Methods to find positions for data
private extension SimpleQRImageGenerator {
    func generatePositions_(qrCode: QRCode) -> Positions {
        var positions = Positions()
        let skipX = QRConstants.searchingPatternSideLen - 1

        var up = true
        let strideForY = {
            defer { up = !up }

            if up {
                return stride(from: qrCode.sideLen - 1, through: 0, by: -1)
            } else {
                return stride(from: 0, through: qrCode.sideLen - 1, by: 1)
            }
        }

        var x = qrCode.sideLen - 1
        while x > 0 {
            guard x != skipX else { x -= 1; continue }

            for y in strideForY() {
                if qrCode[y, x] == Color.notSetted {
                    positions.append((x, y))
                }

                if qrCode[y, x - 1] == Color.notSetted {
                    positions.append((x - 1, y))
                }
            }

            x -= 2
        }

        return positions
    }
}

//MARK: - Methods to make adding patterns work more convenient
private extension SimpleQRImageGenerator {
    func addQRSquareWithBorder_(qrCode: inout QRCode, startX: Int, startY: Int, sideLen: Int) {
        // Add main square
        addQRSquare_(qrCode: &qrCode, startX: startX, startY: startY, sideLen: sideLen)

        // Add white border
        addSquareBorder_(qrCode: &qrCode,
                         square: Square(x: startX - 1, y: startY - 1, side: sideLen + 2),
                         color: Color.white)
    }

    func addQRSquare_(qrCode: inout QRCode, startX: Int, startY: Int, sideLen: Int) {
        // Square in the center
        addFilledSquare_(qrCode: &qrCode,
                         square: Square(x: startX + 2, y: startY + 2, side: sideLen - 3),
                         color: Color.black)

        // White inner border
        addSquareBorder_(qrCode: &qrCode,
                         square: Square(x: startX + 1, y: startY + 1, side: sideLen - 2),
                         color: Color.white)

        // Black outer border
        addSquareBorder_(qrCode: &qrCode,
                         square: Square(x: startX, y: startY, side: sideLen),
                         color: Color.black)
    }

    func addSquareBorder_(qrCode: inout QRCode, square: Square, color: Color) {
        guard square.side > 2 else {
            fatalError("Too small square to add!")
        }

        for i in 0..<square.side {
            qrCode[square.y, square.x + i] = color // Up border
            qrCode[square.y + square.side - 1, square.x + i] = color // Down border
        }

        for i in 1..<(square.side - 1) {
            qrCode[square.y + i, square.x] = color // Left border
            qrCode[square.y + i, square.x + square.side - 1] = color // Right border
        }
    }

    func addFilledSquare_(qrCode: inout QRCode, square: Square, color: Color) {
        guard square.side >= 1 else {
            fatalError("Too small filled square to add!")
        }

        for y in 0..<square.side {
            for x in 0..<square.side {
                qrCode[square.y + y, square.x + x] = color
            }
        }
    }

    func toColors_(str: String) -> [Color] {
        var colors = [Color]()
        colors.reserveCapacity(str.count)

        for char in str {
            switch char {
            case "1": colors.append(.black)
            case "0": colors.append(.white)
            default: fatalError("String must contain only 0 and 1!")
            }
        }

        return colors
    }
}

//MARK: - Methods to render generated QR code to UIImage
extension SimpleQRImageGenerator {
    private func render_(qrCode: QRCode) -> UIImage {
        let toModule = Int(ceil(screenSideMinSize / CGFloat(qrCode.renderSideLen)))
        let sideSize = qrCode.renderSideLen * toModule

        let renderer = UIGraphicsImageRenderer(size: CGSize(width: sideSize, height: sideSize))
        return renderer.image { context in
            for (yModule, line) in qrCode.qrData.enumerated() {
                let y = yModule * toModule

                for (xModule, module) in line.enumerated() {
                    let x = xModule * toModule

                    module.toUIColor().setFill()
                    context.fill(CGRect(x: x, y: y, width: toModule, height: toModule))
                }
            }
        }
    }
}
