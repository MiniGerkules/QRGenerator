//
//  QRVersion.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 17.09.2023.
//

struct QRVersion: Equatable {
    let value: Int

    init?(version: Int) {
        guard QRConstants.versions.contains(version) else { return nil }
        
        self.value = version
    }

    func next() -> QRVersion? {
        return QRVersion(version: value + 1)
    }
}
