//
//  QRConstants.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 08.09.2023.
//

struct QRConstants {
    //MARK: - Types for more convenient work
    enum CorrectionLevel: Int, CaseIterable {
        case L = 7
        case M = 15
        case Q = 25
        case H = 30

        func getDesc() -> String {
            return "\(self) (\(self.rawValue)%)"
        }
    }

    struct CorLevelAndMaskID: Hashable {
        let corLevel: CorrectionLevel
        let maskID: Int
    }

    //MARK: - Static fields
    static let versions = 1...40
    static let correctionLevels = CorrectionLevel.allCases

    static let maxDataSize = [
        CorrectionLevel.L : [
            152, 272, 440, 640, 864, 1088, 1248, 1552, 1856, 2192,
            2592, 2960, 3424, 3688, 4184, 4712, 5176, 5768, 6360, 6888,
            7456, 8048, 8752, 9392, 10208, 10960, 11744, 12248, 13048, 13880,
            14744, 15640, 16568, 17528, 18448, 19472, 20528, 21616, 22496, 23648
        ],
        CorrectionLevel.M : [
            128, 224, 352, 512, 688, 864, 992, 1232, 1456, 1728,
            2032, 2320, 2672, 2920, 3320, 3624, 4056, 4504, 5016, 5352,
            5712, 6256, 6880, 7312, 8000, 8496, 9024, 9544, 10136, 10984,
            11640, 12328, 13048, 13800, 14496, 15312, 15936, 16816, 17728, 18672
        ],
        CorrectionLevel.Q : [
            104, 176, 272, 384, 496, 608, 704, 880, 1056, 1232,
            1440, 1648, 1952, 2088, 2360, 2600, 2936, 3176, 3560, 3880,
            4096, 4544, 4912, 5312, 5744, 6032, 6464, 6968, 7288, 7880,
            8264, 8920, 9368, 9848, 10288, 10832, 11408, 12016, 12656, 13328
        ],
        CorrectionLevel.H : [
            72, 128, 208, 288, 368, 480, 528, 688, 800, 976,
            1120, 1264, 1440, 1576, 1784, 2024, 2264, 2504, 2728, 3080,
            3248, 3536, 3712, 4112, 4304, 4768, 5024, 5288, 5608, 5960,
            6344, 6760, 7208, 7688, 7888, 8432, 8768, 9136, 9776, 10208
        ]
    ]

    static let numOfBlocks = [
        CorrectionLevel.L : [
            1, 1, 1, 1, 1, 2, 2, 2, 2, 4,
            4, 4, 4, 4, 6, 6, 6, 6, 7, 8,
            8, 9, 9, 10, 12, 12, 12, 13, 14, 15,
            16, 17, 18, 19, 19, 20, 21, 22, 24, 25
        ],
        CorrectionLevel.M : [
            1, 1, 1, 2, 2, 4, 4, 4, 5, 5,
            5, 8, 9, 9, 10, 10, 11, 13, 14, 16,
            17, 17, 18, 20, 21, 23, 25, 26, 28, 29,
            31, 33, 35, 37, 38, 40, 43, 45, 47, 49
        ],
        CorrectionLevel.Q : [
            1, 1, 2, 2, 4, 4, 6, 6, 8, 8,
            8, 10, 12, 16, 12, 17, 16, 18, 21, 20,
            23, 23, 25, 27, 29, 34, 34, 35, 38, 40,
            43, 45, 48, 51, 53, 56, 59, 62, 65, 68
        ],
        CorrectionLevel.H : [
            1, 1, 2, 4, 4, 4, 5, 6, 8, 8,
            11, 11, 16, 16, 18, 16, 19, 21, 25, 25,
            25, 34, 30, 32, 35, 37, 40, 42, 45, 48,
            51, 54, 57, 60, 63, 66, 70, 74, 77, 81
        ]
    ]

    static let numOfCorrectionBytes = [
        CorrectionLevel.L : [
            7, 10, 15, 20, 26, 18, 20, 24, 30, 18,
            20, 24, 26, 30, 22, 24, 28, 30, 28, 28,
            28, 28, 30, 30, 26, 28, 30, 30, 30, 30,
            30, 30, 30, 30, 30, 30, 30, 30, 30, 30
        ],
        CorrectionLevel.M : [
            10, 16, 26, 18, 24, 16, 18, 22, 22, 26,
            30, 22, 22, 24, 24, 28, 28, 26, 26, 26,
            26, 28, 28, 28, 28, 28, 28, 28, 28, 28,
            28, 28, 28, 28, 28, 28, 28, 28, 28, 28
        ],
        CorrectionLevel.Q : [
            13, 22, 18, 26, 18, 24, 18, 22, 20, 24,
            28, 26, 24, 20, 30, 24, 28, 28, 26, 30,
            28, 30, 30, 30, 30, 28, 30, 30, 30, 30,
            30, 30, 30, 30, 30, 30, 30, 30, 30, 30
        ],
        CorrectionLevel.H : [
            17, 28, 22, 16, 22, 28, 26, 26, 24, 28,
            24, 28, 22, 24, 24, 30, 28, 28, 26, 28,
            30, 24, 30, 30, 30, 30, 30, 30, 30, 30,
            30, 30, 30, 30, 30, 30, 30, 30, 30, 30
        ]
    ]

    static let polynomials = [
        7 : [87, 229, 146, 149, 238, 102, 21],
        10 : [251, 67, 46, 61, 118, 70, 64, 94, 32, 45],
        13 : [74, 152, 176, 100, 86, 100, 106, 104, 130, 218, 206, 140, 78],
        15 : [8, 183, 61, 91, 202, 37, 51, 58, 58, 237, 140, 124, 5, 99, 105],
        16 : [120, 104, 107, 109, 102, 161, 76, 3, 91, 191, 147, 169, 182, 194,
              225, 120],
        17 : [43, 139, 206, 78, 43, 239, 123, 206, 214, 147, 24, 99, 150, 39, 243,
              163, 136],
        18 : [215, 234, 158, 94, 184, 97, 118, 170, 79, 187, 152, 148, 252, 179,
              5, 98, 96, 153],
        20 : [17, 60, 79, 50, 61, 163, 26, 187, 202, 180, 221, 225, 83, 239, 156,
              164, 212, 212, 188, 190],
        22 : [210, 171, 247, 242, 93, 230, 14, 109, 221, 53, 200, 74, 8, 172, 98,
              80, 219, 134, 160, 105, 165, 231],
        24 : [229, 121, 135, 48, 211, 117, 251, 126, 159, 180, 169, 152, 192, 226,
              228, 218, 111, 0, 117, 232, 87, 96, 227, 21],
        26 : [173, 125, 158, 2, 103, 182, 118, 17, 145, 201, 111, 28, 165, 53,
              161, 21, 245, 142, 13, 102, 48, 227, 153, 145, 218, 70],
        28 : [168, 223, 200, 104, 224, 234, 108, 180, 110, 190, 195, 147, 205, 27,
              232, 201, 21, 43, 245, 87, 42, 195, 212, 119, 242, 37, 9, 123],
        30 : [41, 173, 145, 152, 216, 31, 179, 182, 50, 48, 110, 86, 239, 96, 222,
              125, 42, 173, 226, 193, 224, 130, 156, 37, 251, 216, 238, 40, 192, 180]
    ]

    /// Galois' field for p = 256
    static let galoisField = [
        1, 2, 4, 8, 16, 32, 64, 128, 29, 58, 116, 232, 205, 135, 19, 38,
        76, 152, 45, 90, 180, 117, 234, 201, 143, 3, 6, 12, 24, 48, 96, 192,
        157, 39, 78, 156, 37, 74, 148, 53, 106, 212, 181, 119, 238, 193, 159, 35,
        70, 140, 5, 10, 20, 40, 80, 160, 93, 186, 105, 210, 185, 111, 222, 161,
        95, 190, 97, 194, 153, 47, 94, 188, 101, 202, 137, 15, 30, 60, 120, 240,
        253, 231, 211, 187, 107, 214, 177, 127, 254, 225, 223, 163, 91, 182, 113, 226,
        217, 175, 67, 134, 17, 34, 68, 136, 13, 26, 52, 104, 208, 189, 103, 206,
        129, 31, 62, 124, 248, 237, 199, 147, 59, 118, 236, 197, 151, 51, 102, 204,
        133, 23, 46, 92, 184, 109, 218, 169, 79, 158, 33, 66, 132, 21, 42, 84,
        168, 77, 154, 41, 82, 164, 85, 170, 73, 146, 57, 114, 228, 213, 183, 115,
        230, 209, 191, 99, 198, 145, 63, 126, 252, 229, 215, 179, 123, 246, 241, 255,
        227, 219, 171, 75, 150, 49, 98, 196, 149, 55, 110, 220, 165, 87, 174, 65,
        130, 25, 50, 100, 200, 141, 7, 14, 28, 56, 112, 224, 221, 167, 83, 166,
        81, 162, 89, 178, 121, 242, 249, 239, 195, 155, 43, 86, 172, 69, 138, 9,
        18, 36, 72, 144, 61, 122, 244, 245, 247, 243, 251, 235, 203, 139, 11, 22,
        44, 88, 176, 125, 250, 233, 207, 131, 27, 54, 108, 216, 173, 71, 142, 1
    ]

    /// Inverse Galois' field for p = 256
    static let inverseGaloisField = [
        -1, 0, 1, 25, 2, 50, 26, 198, 3, 223, 51, 238, 27, 104, 199, 75,
        4, 100, 224, 14, 52, 141, 239, 129, 28, 193, 105, 248, 200, 8, 76, 113,
        5, 138, 101, 47, 225, 36, 15, 33, 53, 147, 142, 218, 240, 18, 130, 69,
        29, 181, 194, 125, 106, 39, 249, 185, 201, 154, 9, 120, 77, 228, 114, 166,
        6, 191, 139, 98, 102, 221, 48, 253, 226, 152, 37, 179, 16, 145, 34, 136,
        54, 208, 148, 206, 143, 150, 219, 189, 241, 210, 19, 92, 131, 56, 70, 64,
        30, 66, 182, 163, 195, 72, 126, 110, 107, 58, 40, 84, 250, 133, 186, 61,
        202, 94, 155, 159, 10, 21, 121, 43, 78, 212, 229, 172, 115, 243, 167, 87,
        7, 112, 192, 247, 140, 128, 99, 13, 103, 74, 222, 237, 49, 197, 254, 24,
        227, 165, 153, 119, 38, 184, 180, 124, 17, 68, 146, 217, 35, 32, 137, 46,
        55, 63, 209, 91, 149, 188, 207, 205, 144, 135, 151, 178, 220, 252, 190, 97,
        242, 86, 211, 171, 20, 42, 93, 158, 132, 60, 57, 83, 71, 109, 65, 162,
        31, 45, 67, 216, 183, 123, 164, 118, 196, 23, 73, 236, 127, 12, 111, 246,
        108, 161, 59, 82, 41, 157, 85, 170, 251, 96, 134, 177, 187, 204, 62, 90,
        203, 89, 95, 176, 156, 169, 160, 81, 11, 245, 22, 235, 122, 117, 44, 215,
        79, 174, 213, 233, 230, 231, 173, 232, 116, 214, 244, 234, 168, 80, 88, 175
    ]

    static let qrCodeBorderLen = 4

    /// Coordinations of alignment patterns without white border.
    static let locationsOfLevelingPatterns = [
        [], [18], [22], [26], [30], [34], [6, 22, 38], [6, 24, 42], [6, 26, 46],
        [6, 28, 50], [6, 30, 54], [6, 32, 58], [6, 34, 62], [6, 26, 46, 66],
        [6, 26, 48, 70], [6, 26, 50, 74], [6, 30, 54, 78], [6, 30, 56, 82],
        [6, 30, 58, 86], [6, 34, 62, 90], [6, 28, 50, 72, 94], [6, 26, 50, 74, 98],
        [6, 30, 54, 78, 102], [6, 28, 54, 80, 106], [6, 32, 58, 84, 110],
        [6, 30, 58, 86, 114], [6, 34, 62, 90, 118], [6, 26, 50, 74, 98, 122],
        [6, 30, 54, 78, 102, 126], [6, 26, 52, 78, 104, 130], [6, 30, 56, 82, 108, 134],
        [6, 34, 60, 86, 112, 138], [6, 30, 58, 86, 114, 142], [6, 34, 62, 90, 118, 146],
        [6, 30, 54, 78, 102, 126, 150], [6, 24, 50, 76, 102, 128, 154],
        [6, 28, 54, 80, 106, 132, 158], [6, 32, 58, 84, 110, 136, 162],
        [6, 26, 54, 82, 110, 138, 166], [6, 30, 58, 86, 114, 142, 170]
    ]

    static let qrVersionsID = [
        7  : "000010011110100110",
        8  : "010001011100111000",
        9  : "110111011000000100",
        10 : "101001111110000000",
        11 : "001111111010111100",
        12 : "001101100100011010",
        13 : "101011100000100110",
        14 : "110101000110100010",
        15 : "010011000010011110",
        16 : "011100010001011100",
        17 : "111010010101100000",
        18 : "100100110011100100",
        19 : "000010110111011000",
        20 : "000000101001111110",
        21 : "100110101101000010",
        22 : "111000001011000110",
        23 : "011110001111111010",
        24 : "001101001101100100",
        25 : "101011001001011000",
        26 : "110101101111011100",
        27 : "010011101011100000",
        28 : "010001110101000110",
        29 : "110111110001111010",
        30 : "101001010111111110",
        31 : "001111010011000010",
        32 : "101000011000101101",
        33 : "001110011100010001",
        34 : "010000111010010101",
        35 : "110110111110101001",
        36 : "110100100000001111",
        37 : "010010100100110011",
        38 : "001100000010110111",
        39 : "101010000110001011",
        40 : "111001000100010101"
    ]

    typealias MaskFunction = (Int, Int) -> Int

    static let masks: [Int : MaskFunction] = [
        0 : { x, y in (x+y) % 2 },
        1 : { _, y in y % 2 },
        2 : { x, _ in x % 3 },
        3 : { x, y in (x+y) % 3 },
        4 : { x, y in (x/3 + y/2) % 2 },
        5 : { x, y in (x*y) % 2 + (x*y) % 3 },
        6 : { x, y in ((x*y) % 2 + (x*y) % 3) % 2 },
        7 : { x, y in ((x*y) % 3 + (x+y) % 2) % 2 }
    ]

    static let codeOfMaskAndCorrectionLevel: [CorLevelAndMaskID : String] = [
        CorLevelAndMaskID(corLevel: .L, maskID: 0) : "111011111000100",
        CorLevelAndMaskID(corLevel: .L, maskID: 1) : "111001011110011",
        CorLevelAndMaskID(corLevel: .L, maskID: 2) : "111110110101010",
        CorLevelAndMaskID(corLevel: .L, maskID: 3) : "111100010011101",
        CorLevelAndMaskID(corLevel: .L, maskID: 4) : "110011000101111",
        CorLevelAndMaskID(corLevel: .L, maskID: 5) : "110001100011000",
        CorLevelAndMaskID(corLevel: .L, maskID: 6) : "110110001000001",
        CorLevelAndMaskID(corLevel: .L, maskID: 7) : "110100101110110",
        CorLevelAndMaskID(corLevel: .M, maskID: 0) : "101010000010010",
        CorLevelAndMaskID(corLevel: .M, maskID: 1) : "101000100100101",
        CorLevelAndMaskID(corLevel: .M, maskID: 2) : "101111001111100",
        CorLevelAndMaskID(corLevel: .M, maskID: 3) : "101101101001011",
        CorLevelAndMaskID(corLevel: .M, maskID: 4) : "100010111111001",
        CorLevelAndMaskID(corLevel: .M, maskID: 5) : "100000011001110",
        CorLevelAndMaskID(corLevel: .M, maskID: 6) : "100111110010111",
        CorLevelAndMaskID(corLevel: .M, maskID: 7) : "100101010100000",
        CorLevelAndMaskID(corLevel: .Q, maskID: 0) : "011010101011111",
        CorLevelAndMaskID(corLevel: .Q, maskID: 1) : "011000001101000",
        CorLevelAndMaskID(corLevel: .Q, maskID: 2) : "011111100110001",
        CorLevelAndMaskID(corLevel: .Q, maskID: 3) : "011101000000110",
        CorLevelAndMaskID(corLevel: .Q, maskID: 4) : "010010010110100",
        CorLevelAndMaskID(corLevel: .Q, maskID: 5) : "010000110000011",
        CorLevelAndMaskID(corLevel: .Q, maskID: 6) : "010111011011010",
        CorLevelAndMaskID(corLevel: .Q, maskID: 7) : "010101111101101",
        CorLevelAndMaskID(corLevel: .H, maskID: 0) : "001011010001001",
        CorLevelAndMaskID(corLevel: .H, maskID: 1) : "001001110111110",
        CorLevelAndMaskID(corLevel: .H, maskID: 2) : "001110011100111",
        CorLevelAndMaskID(corLevel: .H, maskID: 3) : "001100111010000",
        CorLevelAndMaskID(corLevel: .H, maskID: 4) : "000011101100010",
        CorLevelAndMaskID(corLevel: .H, maskID: 5) : "000001001010101",
        CorLevelAndMaskID(corLevel: .H, maskID: 6) : "000110100001100",
        CorLevelAndMaskID(corLevel: .H, maskID: 7) : "000100000111011"
    ]

    static let searchingPatternSideLen = 7
    static let levelingPatternSideLen = 5

    //MARK: - Static methods
    static func getMaxDataSize(for correctionLevel: CorrectionLevel,
                               version: QRVersion) -> Int {
        return maxDataSize[correctionLevel]![version.value - 1]
    }

    static func getNumOfBlocks(for correctionLevel: CorrectionLevel,
                               version: QRVersion) -> Int {
        return numOfBlocks[correctionLevel]![version.value - 1]
    }

    static func getNumOfCorrectionBytes(for correctionLevel: CorrectionLevel,
                                        version: QRVersion) -> Int {
        return numOfCorrectionBytes[correctionLevel]![version.value - 1]
    }

    static func getQRCodeSideSize(version: QRVersion) -> Int {
        guard version.value > 1 else { return 21 }

        return locationsOfLevelingPatterns[version.value - 1].last! + 7
    }

    static func getCentersOfLevelingPatterns(version: QRVersion) -> [(Int, Int)] {
        let levelingPatterns = locationsOfLevelingPatterns[version.value - 1]

        var locations = [(Int, Int)]()
        locations.reserveCapacity(levelingPatterns.count * levelingPatterns.count)

        for first in levelingPatterns {
            for second in levelingPatterns {
                locations.append((first, second)) // All permutations
            }
        }

        if version.value > 6 {
            let sourceNumOfElems = levelingPatterns.count

            locations.remove(at: locations.count - sourceNumOfElems) // (last, last)
            locations.remove(at: sourceNumOfElems - 1) // (first, last)
            locations.remove(at: 0) // (first, first)
        }

        return locations
    }

    static func getCodeOfMaskAndCorLevel(for correctionLevel: CorrectionLevel,
                                         and muskID: Int) -> String? {
        let key = CorLevelAndMaskID(corLevel: correctionLevel, maskID: muskID)

        return codeOfMaskAndCorrectionLevel[key]
    }
}
