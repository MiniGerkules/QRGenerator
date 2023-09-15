//
//  QRPresentingViewController.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 08.09.2023.
//

import UIKit

class QRPresentingViewController: UIViewController {
    private let imagePlaceholder = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Generated QR"

        setupView()
    }

    func setup(show: UIImage) {
        imagePlaceholder.image = show
    }
}

//MARK: - Appearance functions
private extension QRPresentingViewController {
    func setupView() {
        view.addSubview(imagePlaceholder)

        imagePlaceholder.translatesAutoresizingMaskIntoConstraints = false

        let safe = view.safeAreaLayoutGuide
        let side = 0.9 * min(safe.layoutFrame.size.width, safe.layoutFrame.size.height)

        NSLayoutConstraint.activate([
            imagePlaceholder.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            imagePlaceholder.centerYAnchor.constraint(equalTo: safe.centerYAnchor),

            imagePlaceholder.widthAnchor.constraint(equalToConstant: side),
            imagePlaceholder.heightAnchor.constraint(equalToConstant: side),
        ])
    }
}
