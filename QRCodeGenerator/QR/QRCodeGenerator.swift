//
//  QRCodeGenerator.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 16.09.2023.
//

struct QRCodeGenerator {
    private init() { } // Remove default init. Use struct as a namespace.

    static func generateQRCode(qrData: QRData, correctionLevel: QRConstants.CorrectionLevel,
                               version: QRVersion) -> QRCode {
        let sideSizeInModules = QRConstants.getQRCodeSideSize(version: version)
        var qrCode = QRCode(qrCodeSideLen: sideSizeInModules)

        addSearchPatterns_(qrCode: &qrCode)
        addSyncLines_(qrCode: &qrCode)
        addLevelingPatterns_(qrCode: &qrCode, version: version)
        addQRCodeVersion_(qrCode: &qrCode, version: version)

        addCorrectionLevelMaskAndData_(qrCode: &qrCode, qrData: qrData,
                                       correctionLevel: correctionLevel)

        return qrCode
    }
}

//MARK: - Types to make work more convenient
private extension QRCodeGenerator {
    struct Square {
        let x, y: Int
        let side: Int

        var squarePositions: Positions {
            var positions = Positions()
            positions.reserveCapacity(side * side)

            for yBias in 0..<side {
                for xBias in 0..<side {
                    positions.append(Position(x: x + xBias, y: y + yBias))
                }
            }

            return positions
        }
    }

    struct Position: Hashable {
        let x, y: Int
        var tuple: (Int, Int) { (x, y) }
    }

    typealias Positions = [Position]
}

//MARK: - Methods to fill QR code with data
private extension QRCodeGenerator {
    static func addSearchPatterns_(qrCode: inout QRCode) {
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

    static func addLevelingPatterns_(qrCode: inout QRCode, version: QRVersion) {
        let points = QRConstants.getCentersOfLevelingPatterns(version: version)
        let sideLen = QRConstants.levelingPatternSideLen

        for (x, y) in points {
            let trueX = x - sideLen/2, trueY = y - sideLen/2
            addQRSquare_(qrCode: &qrCode, startX: trueX, startY: trueY, sideLen: sideLen)
        }
    }

    static func addSyncLines_(qrCode: inout QRCode) {
        let start = QRConstants.searchingPatternSideLen + 1
        let end = qrCode.sideLen - start

        let level = QRConstants.searchingPatternSideLen - 1

        for elem in stride(from: start, to: end, by: 2) {
            qrCode[level, elem] = .withData
            qrCode[elem, level] = .withData
        }

        for elem in stride(from: start + 1, to: end, by: 2) {
            qrCode[level, elem] = .withoutData
            qrCode[elem, level] = .withoutData
        }
    }

    static func addQRCodeVersion_(qrCode: inout QRCode, version: QRVersion) {
        guard let versionID = QRConstants.qrVersionsID[version.value] else { return }

        let modules = toModules_(str: versionID)
        guard modules.count == 18 else { return }

        let numOfRows = 3 // Number of rows to encode version of QR
        let startY = qrCode.sideLen - QRConstants.searchingPatternSideLen - numOfRows - 1
        let startX = 0

        for row in 0..<numOfRows {
            let start = row * 6, end = start + 6

            for (column, module) in modules[start..<end].enumerated() {
                qrCode[startY + row, startX + column] = module
                qrCode[startX + column, startY + row] = module
            }
        }
    }
}

//MARK: - Methods to make adding patterns work more convenient
private extension QRCodeGenerator {
    static func addQRSquareWithBorder_(qrCode: inout QRCode, startX: Int, startY: Int, sideLen: Int) {
        // Add main square
        addQRSquare_(qrCode: &qrCode, startX: startX, startY: startY, sideLen: sideLen)

        // Add white border
        addSquareBorder_(qrCode: &qrCode,
                         square: Square(x: startX - 1, y: startY - 1, side: sideLen + 2),
                         module: .withoutData)
    }

    static func addQRSquare_(qrCode: inout QRCode, startX: Int, startY: Int, sideLen: Int) {
        // Square in the center
        addFilledSquare_(qrCode: &qrCode,
                         square: Square(x: startX + 2, y: startY + 2, side: sideLen - 4),
                         module: .withData)

        // White inner border
        addSquareBorder_(qrCode: &qrCode,
                         square: Square(x: startX + 1, y: startY + 1, side: sideLen - 2),
                         module: .withoutData)

        // Black outer border
        addSquareBorder_(qrCode: &qrCode,
                         square: Square(x: startX, y: startY, side: sideLen),
                         module: .withData)
    }

    static func addSquareBorder_(qrCode: inout QRCode, square: Square, module: QRCode.Module) {
        guard square.side > 2 else {
            fatalError("Too small square to add!")
        }

        for i in 0..<square.side {
            qrCode[square.y, square.x + i] = module // Up border
            qrCode[square.y + square.side - 1, square.x + i] = module // Down border
        }

        for i in 1..<(square.side - 1) {
            qrCode[square.y + i, square.x] = module // Left border
            qrCode[square.y + i, square.x + square.side - 1] = module // Right border
        }
    }

    static func addFilledSquare_(qrCode: inout QRCode, square: Square, module: QRCode.Module) {
        guard square.side >= 1 else {
            fatalError("Too small filled square to add!")
        }

        for position in square.squarePositions {
            qrCode[position.x, position.y] = module
        }
    }
}

//MARK: - Methods to add correction level, mask and data to QR code
private extension QRCodeGenerator {
    static func addCorrectionLevelMaskAndData_(qrCode: inout QRCode,
                                               qrData: QRData,
                                               correctionLevel: QRConstants.CorrectionLevel) {
        // Reserve pixels to not fill them with data
        addCorrectionLevelAndMask_(qrCode: &qrCode,
                                   module: [QRCode.Module](repeating: .withoutData, count: 15))

        let positions = generatePositions_(qrCode: qrCode)
        let bestMaskID = getBestMaskID_(qrCode: qrCode, qrData: qrData,
                                        correctionLevel: correctionLevel,
                                        positions: positions)
        let maskFunc = QRConstants.masks[bestMaskID]!

        addQRData_(qrCode: &qrCode, qrData: qrData, positions: positions,
                   maskFunc: maskFunc)
        let modules = toModules_(
            str: QRConstants.getCodeOfMaskAndCorLevel(
                for: correctionLevel, and: bestMaskID
            )!
        )
        addCorrectionLevelAndMask_(qrCode: &qrCode, module: modules)
    }

    static func addCorrectionLevelAndMask_(qrCode: inout QRCode, module: [QRCode.Module]) {
        guard module.count == 15 else {
            fatalError("The correction level and mask code must consist of 15 modules!")
        }

        let level = QRConstants.searchingPatternSideLen + 1
        let bias = { (ind: Int) in return ind >= 6 ? 1 : 0 }

        // Upper left corner
        for (ind, module) in module.prefix(7).enumerated() {
            qrCode[level, ind + bias(ind)] = module // Down border
        }

        for (ind, module) in module.suffix(8).reversed().enumerated() {
            qrCode[ind + bias(ind), level] = module // Left border
        }

        // Lower left corner
        for (ind, module) in module.prefix(7).enumerated() {
            qrCode[qrCode.sideLen - 1 - ind, level] = module
        }
        qrCode[qrCode.sideLen - 1 - 7, level] = .withData // Must always be black

        // Upper right corner
        for (ind, module) in module.suffix(8).reversed().enumerated() {
            qrCode[level, qrCode.sideLen - 1 - ind] = module
        }
    }

    static func getBestMaskID_(qrCode: QRCode, qrData: QRData,
                               correctionLevel: QRConstants.CorrectionLevel,
                               positions: Positions) -> Int {
        var qrCode = qrCode
        var penaltyPoints = [Int : Int]()

        for (maskID, maskFunc) in QRConstants.masks {
            addQRData_(qrCode: &qrCode, qrData: qrData, positions: positions,
                       maskFunc: maskFunc)

            let modules = toModules_(
                str: QRConstants.getCodeOfMaskAndCorLevel(
                    for: correctionLevel, and: maskID
                )!
            )
            addCorrectionLevelAndMask_(qrCode: &qrCode, module: modules)

            penaltyPoints[maskID] = countPenaltyPoints_(for: qrCode)
        }

        return penaltyPoints.min { $0.value < $1.value }!.key
    }

    static func addQRData_(qrCode: inout QRCode, qrData: QRData, positions: Positions,
                           maskFunc: QRConstants.MaskFunction) {
        var cur = positions.startIndex

        for num in qrData {
            let modules = toModules_(str: num.toBinString())

            for module in modules {
                let (x, y) = positions[cur].tuple
                qrCode[y, x] = maskFunc(x, y) != 0 ? module : !module

                cur = positions.index(after: cur)
            }
        }

        while cur < positions.endIndex {
            let (x, y) = positions[cur].tuple
            qrCode[y, x] = .withoutData

            cur = positions.index(after: cur)
        }
    }
}

//MARK: - Methods to find positions for data
private extension QRCodeGenerator {
    static func generatePositions_(qrCode: QRCode) -> Positions {
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
                if qrCode[y, x] == .notSetted {
                    positions.append(Position(x: x, y: y))
                }

                if qrCode[y, x - 1] == .notSetted {
                    positions.append(Position(x: x - 1, y: y))
                }
            }

            x -= 2
        }

        return positions
    }
}

//MARK: - Methods that count penalty points for generated QR
private extension QRCodeGenerator {
    static func countPenaltyPoints_(for qrCode: QRCode) -> Int {
        return countPenaltyPointsForLines_(for: qrCode) +
               countPenaltyPointsForSquares_(for: qrCode) +
               countPenaltyPointsForSpecialPattern_(for: qrCode) +
               countPenaltyPointsForModulesDiff_(for: qrCode)
    }

    static func countPenaltyPointsForLines_(for qrCode: QRCode) -> Int {
        let penaltyCounter = { (x: Int, y: Int, prevModule: inout QRCode.Module,
                                modulesNum: inout Int, penalty: inout Int) in
            if qrCode[y, x] == prevModule {
                modulesNum += 1

                if modulesNum == 5 {
                    penalty += 3
                } else if modulesNum > 5 {
                    penalty += 1
                }
            } else {
                prevModule = qrCode[y, x]
                modulesNum = 1
            }
        }

        var xPenalty = 0, yPenalty = 0

        for i in 0..<qrCode.sideLen {
            var xBlocks = 0, yBlocks = 0
            var xModule = qrCode[0, i], yModule = qrCode[i, 0]

            for j in 0..<qrCode.sideLen {
                penaltyCounter(j, i, &xModule, &xBlocks, &xPenalty)
                penaltyCounter(i, j, &yModule, &yBlocks, &yPenalty)
            }
        }

        return xPenalty + yPenalty
    }

    static func countPenaltyPointsForSquares_(for qrCode: QRCode) -> Int {
        var blocks = 0

        for y in 0..<(qrCode.sideLen - 1) {
            for x in 0..<(qrCode.sideLen - 1) {
                let square = Square(x: x, y: y, side: 2)
                let withData = countModulesNum_(for: qrCode, in: square, module: .withData)
                let withoutData = countModulesNum_(for: qrCode, in: square, module: .withoutData)

                if withData == square.side*square.side || withoutData == square.side*square.side {
                    blocks += 1
                }
            }
        }

        return blocks * 3 // 3 -- penalty for a 2x2 block
    }

    static func countPenaltyPointsForSpecialPattern_(for qrCode: QRCode) -> Int {
        var column = [QRCode.Module](repeating: .withoutData, count: qrCode.sideLen)
        var row = [QRCode.Module](repeating: .withoutData, count: qrCode.sideLen)
        var penaltyPoints = 0

        for i in 0..<qrCode.sideLen {
            for j in 0..<qrCode.sideLen {
                row[j] = qrCode[i, j]
                column[j] = qrCode[j, i]
            }

            penaltyPoints += countPenaltyPointsForSpecialPattern_(for: row)
            penaltyPoints += countPenaltyPointsForSpecialPattern_(for: column)
        }

        return penaltyPoints
    }

    static func countPenaltyPointsForSpecialPattern_(for modules: [QRCode.Module]) -> Int {
        let mainPattern: [QRCode.Module] = [.withData, .withoutData, .withData, .withData,
                                            .withData, .withoutData, .withData]
        let patternSide: [QRCode.Module] = [.withoutData, .withoutData, .withoutData, .withoutData]

        let isEqualToPattern = { (range: Range) in
            return range.lowerBound >= modules.startIndex && range.upperBound <= modules.endIndex &&
                   modules[range] == patternSide[...]
        }


        let ranges = modules.ranges(of: mainPattern)
        var blocks = 0

        for range in ranges {
            let newStart = range.lowerBound - patternSide.count
            let newEnd = range.upperBound + patternSide.count + 1

            if isEqualToPattern(newStart..<range.lowerBound) ||
                    isEqualToPattern((range.upperBound + 1)..<newEnd) {
                penaltyPoints += 40
            }
        }

        return blocks * 40 // 40 -- penalty for a pattern
    }

    static func countPenaltyPointsForModulesDiff_(for qrCode: QRCode) -> Int {
        let modWithDataNum = countModulesNum_(for: qrCode,
                                              in: Square(x: 0, y: 0, side: qrCode.sideLen),
                                              module: .withData)

        let proportion = Double(modWithDataNum) / Double(qrCode.sideLen * qrCode.sideLen)
        let penaltyPoints = abs(Int(proportion*100 - 50)) * 2

        return penaltyPoints
    }

    static func countModulesNum_(for qrCode: QRCode, in square: Square,
                                 module: QRCode.Module) -> Int {
        var moduleNum = 0

        for position in square.squarePositions {
            if qrCode[position.x, position.y] == module {
                moduleNum += 1
            }
        }

        return moduleNum
    }
}

//MARK: - Method to convert String to array of modules
private extension QRCodeGenerator {
    static func toModules_(str: String) -> [QRCode.Module] {
        var modules = [QRCode.Module]()
        modules.reserveCapacity(str.count)

        for char in str {
            switch char {
            case "1": modules.append(.withData)
            case "0": modules.append(.withoutData)
            default: fatalError("String must contain only 0 and 1!")
            }
        }

        return modules
    }
}
