//
//  NotRotatingNavigationController.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 08.09.2023.
//

import UIKit

final class NotRotatingNavigationController: UINavigationController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
