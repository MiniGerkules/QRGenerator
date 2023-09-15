//
//  QRImageGenerator.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 09.09.2023.
//

import UIKit.UIImage

protocol QRImageGenerator {
    func generateQRImage(qrData: QRData, correctionLevel: QRConstants.CorrectionLevel,
                         version: QRVersion) -> UIImage
}
