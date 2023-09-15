//
//  IntExtensions.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 11.09.2023.
//

extension BinaryInteger {
    func toBinString() -> String {
        let numBits = MemoryLayout.size(ofValue: self) * 8
        var binStr = String(self, radix: 2)

        let diff = numBits - binStr.count
        binStr.insert(contentsOf: String(repeating: "0", count: diff),
                      at: binStr.startIndex)

        return binStr
    }
}
