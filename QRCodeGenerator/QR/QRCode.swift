//
//  QRCode.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 16.09.2023.
//

struct QRCode {
    static let borderLen = QRConstants.qrCodeBorderLen

    private(set) var qrData: [[Module]]

    subscript(y: Int, x: Int) -> Module {
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
            repeating: Array(repeating: Module.notSetted, count: fullSideLen),
            count: fullSideLen
        )

        for along in 0..<renderSideLen {
            for border in 0..<Self.borderLen {
                qrData[along][border] = Module.withoutData // Left border
                qrData[along][renderSideLen - border - 1] = Module.withoutData // Right border

                qrData[border][along] = Module.withoutData // Upper border
                qrData[renderSideLen - border - 1][along] = Module.withoutData // Lower border
            }
        }
    }
}

//MARK: - Extension with Data enum declaration
extension QRCode {
    enum Module {
        case withData, withoutData
        case notSetted

        static prefix func !(data: Module) -> Module {
            switch data {
            case .withData: return .withoutData
            case .withoutData: return .withData
            case .notSetted: fatalError("Color must be setted to be inverted!")
            }
        }
    }
}
