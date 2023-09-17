//
//  ArrayExtension.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 11.09.2023.
//

extension Array {
    /// The method shifts array to the left (in case `num` is positive) or to the right (in case `num` is negative)
    /// to `num` positions. The size will be saved.
    /// - Parameter num: The number to shift array to the right. If it's bigger than `count`, nothing
    /// will happen.
    /// - Parameter filler: The filler to fill edge positions.
    mutating func shiftLeft(by num: Int, filler: Element) {
        guard abs(num) <= count, num != 0 else { return }

        let end: Index
        var to, from: Index
        let moveIndex: (Index) -> Index

        if num > 0 {
            end = endIndex
            to = startIndex; from = index(to, offsetBy: num)
            moveIndex = index(after:)
        } else { // if num < 0
            end = index(before: startIndex)
            to = index(before: endIndex); from = index(to, offsetBy: num)
            moveIndex = index(before:)
        }

        while from != end {
            self[to] = self[from]
            to = moveIndex(to)
            from = moveIndex(from)
        }

        while to != end {
            self[to] = filler
            to = moveIndex(to)
        }
    }
}

extension Array where Element: Collection<UInt8> {
    /// The method merges data of self to `qrData` parameter. Data in `qrData` will be saved!
    ///
    /// The process of combining numbers occurs as follows: first, the first bytes from all arrays are taken,
    /// then the second bytes, then the third, and so on, as long as there is unread data in the arrays. If there
    /// is no data left in the array, it is skipped.
    /// - Parameter qrData: The storage for bytes from the array.
    func merge(to qrData: inout QRData) {
        var indices = map { $0.startIndex }
        var canMove = true

        while canMove {
            canMove = false

            for (ind, elem) in enumerated() {
                if indices[ind] != elem.endIndex {
                    qrData.append(elem[indices[ind]])

                    indices[ind] = elem.index(after: indices[ind])
                    canMove = true
                }
            }
        }
    }
}
