//
//  StringExtensions.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 11.09.2023.
//

extension String {
    /// The method adds `filler` to the end of the string until the string size is aligned to `num`.
    /// - Parameters:
    ///   - num: The number to align the string.
    ///   - filler: The character to fill the string.
    mutating func align(to num: Int, with filler: Character) {
        let repeatNum = (num - count % num) % num
        append(contentsOf: String(repeating: filler, count: repeatNum))
    }

    /// The method splits string into fragments with `numOfElem` elements in each.
    ///
    /// Last chunk may contain not `numOfElem`, if there aren't enough elements. In that case it will contain
    /// `count % numOfElem` elements.
    /// - Parameter numOfElem: The number of elements in each chunk.
    /// - Returns: String splitted to  chunks with `numOfElem` in each (last one can contain less).
    func split(by numOfElem: Int) -> [String.SubSequence]? {
        guard numOfElem > 0 else { return nil }

        let dataSize = count
        var chunks = [String.SubSequence]()
        chunks.reserveCapacity(dataSize/numOfElem + (dataSize%numOfElem != 0 ? 1 : 0))

        var curNum = numOfElem
        var startIndex = startIndex

        for ind in indices {
            if curNum > 0 {
                curNum -= 1
            } else {
                chunks.append(self[startIndex..<ind])

                startIndex = ind
                curNum = numOfElem - 1
            }
        }

        chunks.append(self[startIndex...]) // Last chunk (maybe not full)

        return chunks
    }
}
