//
//  SimpleQRImageGenerator.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 10.09.2023.
//

import UIKit.UIImage

struct SimpleQRImageGenerator: QRImageGenerator {
    let screenSideMinSize: CGFloat

    func generateQRImage(qrCode: QRCode) -> UIImage {
        let toModule = Int(ceil(screenSideMinSize / CGFloat(qrCode.renderSideLen)))
        let sideSize = qrCode.renderSideLen * toModule

        let renderer = UIGraphicsImageRenderer(size: CGSize(width: sideSize, height: sideSize))
        return renderer.image { context in
            for (yModule, line) in qrCode.qrData.enumerated() {
                let y = yModule * toModule

                for (xModule, module) in line.enumerated() {
                    let x = xModule * toModule

                    toUIColor(module: module).setFill()
                    context.fill(CGRect(x: x, y: y, width: toModule, height: toModule))
                }
            }
        }
    }

    private func toUIColor(module: QRCode.Module) -> UIColor {
        switch module {
        case .withData: return UIColor.black
        case .withoutData: return UIColor.white
        case .notSetted: fatalError("All qr modules must have value!")
        }
    }
}
