//
//  QREncoder.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 07.09.2023.
//

//MARK: - Protocol requirements
protocol QREncoder {
    static var dataDesc: String { get }
    static var qrEncodingID: String { get }

    func validateData(_ data: String, correctionLevel: QRConstants.CorrectionLevel) throws
    func generateQRBits(for data: String) -> String

    func getLengthOfSizeField(for qrVersion: QRVersion) -> Int
}

//MARK: - Generation method
extension QREncoder {
    /// The method generates data for a QR code with setted correction level.
    /// - Parameters:
    ///   - data: The data to generate QR code.
    ///   - correctionLevel: Level of errors correction.
    /// - Returns: Generated for `data` QR code bytes.
    func generateQRData(_ data: String,
                        with correctionLevel: QRConstants.CorrectionLevel) throws -> (QRData, QRVersion) {
        try validateData(data, correctionLevel: correctionLevel)

        // Data must be valid
        var qrBits = generateQRBits(for: data)
        let capacities = QRConstants.maxDataSize[correctionLevel]!
        var version = getVersion(qrCodeCapacities: capacities, dataSize: qrBits.count)!

        try addServiceFields(to: &qrBits, sourceDataLen: data.count,
                             correctionLevel: correctionLevel, version: &version)
        qrBits.align(to: 8, with: "0") // 8 = num bits in a byte

        var qrBytes = qrBits.split(by: 8)!.map{ UInt8($0, radix: 2)! }
        let sizeInBitsMustBe = QRConstants.getMaxDataSize(for: correctionLevel, version: version)
        fillDataToSize(&qrBytes, sizeInBitsMustBe: sizeInBitsMustBe)

        let qrBlocks = splitQRBytesToBlocks(qrBytes, correctionLevel: correctionLevel, version: version)
        let numOfCorrBytes = QRConstants.getNumOfCorrectionBytes(for: correctionLevel, version: version)
        let correctionBlocks = qrBlocks.map { qrBlock in
            createCorrectionBlock(for: qrBlock, numOfCorrectionBytes: numOfCorrBytes)
        }

        return (merge(qrBlocks: qrBlocks, correctionBlocks: correctionBlocks), version)
    }
}

//MARK: - Private methods to help generate QR data
private extension QREncoder {
    /// The method finds the version of QR code.
    /// - Parameters:
    ///   - qrCodeCapacities: Capacities of QR code versions in ascending order.
    ///   - dataSize: The size of data to encode.
    /// - Returns: Version of QR code or nil if data is too big for encoding.
    func getVersion(qrCodeCapacities: [Int], dataSize: Int) -> Int? {
        var left = qrCodeCapacities.index(before: qrCodeCapacities.startIndex)
        var right = qrCodeCapacities.endIndex

        while left + 1 < right {
            let mid = left + (right - left) / 2
            if (qrCodeCapacities[mid] < dataSize) {
                left = mid
            } else {
                right = mid
            }
        }

        if right < qrCodeCapacities.endIndex && dataSize <= qrCodeCapacities[right] {
            return right + 1
        } else {
            return nil
        }
    }

    /// The method adds service firled to `mainQRData` string.
    /// - Parameters:
    ///   - mainQRData: String to add data.
    ///   - sourceDataLen: Size of data to encode.
    ///   - correctionLevel: Level of errors correction.
    ///   - version: Version of the generated qr code.
    func addServiceFields(to mainQRData: inout String, sourceDataLen: Int,
                          correctionLevel: QRConstants.CorrectionLevel,
                          version: inout QRVersion) throws {
        let encodedSize = sourceDataLen.toBinString().suffix(getLengthOfSizeField(for: version))
        mainQRData.insert(contentsOf: Self.qrEncodingID + encodedSize, at: mainQRData.startIndex)

        let maxSize = QRConstants.getMaxDataSize(for: correctionLevel, version: version)
        let curSize = mainQRData.count

        if curSize > maxSize {
            if let nextVersion = QRConstants.getNextVersion(currentVersion: version) {
                version = nextVersion
            } else {
                throw EncoderError.tooMuchData
            }
        }
    }

    /// The method append filling bytes to `qrData` to get `sizeMustBe` size.
    /// - Parameters:
    ///   - qrData: The array to fill.
    ///   - sizeInBitsMustBe: The size of resulting array in bits.
    func fillDataToSize(_ qrData: inout QRData, sizeInBitsMustBe: Int) {
        let fillers: QRData = [0b11101100, 0b00010001]


        for i in 0..<(sizeInBitsMustBe/8 - qrData.count) {
            qrData.append(fillers[i % 2])
        }
    }

    /// The method splits QR data to block.
    /// - Parameters:
    ///   - data: Data to split
    ///   - correctionLevel: The level of correction.
    ///   - version: The version of QR code.
    /// - Returns: Block with data from `data` argument.
    func splitQRBytesToBlocks(_ data: QRData, correctionLevel: QRConstants.CorrectionLevel,
                             version: QRVersion) -> LightQRBlocks {
        let numOfBlocks = QRConstants.getNumOfBlocks(for: correctionLevel, version: version)
        var blocks = LightQRBlocks()
        blocks.reserveCapacity(numOfBlocks)

        let sizeOfData = data.count
        let numOfExtendedBlocks = sizeOfData % numOfBlocks

        let numOfElemsInNormalBlock = sizeOfData / numOfBlocks
        let numOfElemsInExtendedBlock = numOfElemsInNormalBlock + 1

        for i in 0..<(numOfBlocks - numOfExtendedBlocks) {
            let startIndex = i*numOfElemsInNormalBlock
            let endIndex = (i+1) * numOfElemsInNormalBlock

            blocks.append(data[startIndex..<endIndex])
        }

        let bias = (numOfBlocks-numOfExtendedBlocks) * numOfElemsInNormalBlock
        for i in 0..<numOfExtendedBlocks {
            let startIndex = bias + i*numOfElemsInExtendedBlock
            let endIndex = startIndex + numOfElemsInExtendedBlock

            blocks.append(data[startIndex..<endIndex])
        }

        return blocks
    }

    /// The methods creates a block of correction bytes.
    /// - Parameters:
    ///   - qrBlock: The block for which the correction block is being created.
    ///   - numOfCorrectionBytes: The number of correction bytes.
    /// - Returns: Block with correction bytes.
    func createCorrectionBlock(for qrBlock: LightQRBlock, numOfCorrectionBytes: Int) -> QRBlock {
        var newBlock = QRBlock(repeating: 0, count: max(qrBlock.count, numOfCorrectionBytes))
        for (ind, val) in qrBlock.enumerated() {
            newBlock[ind] = val
        }

        let polynomial = QRConstants.polynomials[numOfCorrectionBytes]!

        for _ in newBlock.indices {
            let a = newBlock[0]
            newBlock.shiftLeft(by: 1, filler: 0)

            if a == 0 { continue }

            let b = QRConstants.inverseGaloisField[Int(a)]
            for i in 0..<numOfCorrectionBytes {
                let v = (polynomial[i] + b) % 255
                newBlock[i] ^= UInt8(QRConstants.galoisField[v])
            }
        }

        return newBlock
    }

    /// The method merges `qrBlocks` and `correctionBlock` in one array.
    ///
    /// Beginning of the result array will contain data from `qrBlocks` merged with Array.merge method.
    /// After all data of `qrBlocks` will be placed data of `correctionBlocks` also merged with Array.merge.
    /// - Parameters:
    ///   - qrBlocks: Blocks of main qr code data.
    ///   - correctionBlocks: Correction blocks for `qrBlocks`.
    /// - Returns: Array merged from `qrBlocks` and `correctionBlocks`
    func merge(qrBlocks: LightQRBlocks, correctionBlocks: QRBlocks) -> QRData {
        var qrData = QRData()
        qrData.reserveCapacity(2 * qrBlocks.reduce(0) { $0 + $1.count })

        qrBlocks.merge(to: &qrData)
        correctionBlocks.merge(to: &qrData)

        return qrData
    }
}
