//
//  IntExtensions.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 11.09.2023.
//

extension Int {
    func toBinString(numOfBinDigits: Int) -> String.SubSequence? {
        let numBitsInInt = MemoryLayout<Int>.size * 8
        guard numOfBinDigits <= numBitsInInt else { return nil }

        let drop = numBitsInInt - numOfBinDigits
        return String(self, radix: 2).dropFirst(drop)
    }
}
