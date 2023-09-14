//
//  TypeAliases.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 11.09.2023.
//

typealias QRData = [UInt8]

typealias LightQRBlock = QRData.SubSequence
typealias LightQRBlocks = [LightQRBlock]

typealias QRBlock = QRData
typealias QRBlocks = [QRBlock]

typealias Polynomial = [Int]

typealias QRVersion = Int
