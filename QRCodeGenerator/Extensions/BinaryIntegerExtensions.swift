//
//  IntExtensions.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 11.09.2023.
//

extension BinaryInteger {
    /// The method converts self to its binary representation.
    /// - Returns: Binary representation of number.
    func toBinString() -> String {
        let numBits = MemoryLayout.size(ofValue: self) * 8
        var binStr = String(); binStr.reserveCapacity(numBits)

        for i in stride(from: numBits - 1, through: 0, by: -1) {
            let num = (self & (1 << i)) >> i
            binStr.append(String(num * num)) // Multipty to remove sign
        }

        return binStr
    }
}
