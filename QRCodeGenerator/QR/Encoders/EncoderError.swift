//
//  EncoderError.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 08.09.2023.
//

enum EncoderError: Error {
    case tooMuchData
    case dataIsEmpty
    case uncorrectData(String)
}
