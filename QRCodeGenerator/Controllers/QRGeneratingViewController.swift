//
//  QRGeneratingViewController.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 08.09.2023.
//

import UIKit

class QRGeneratingViewController: UIViewController {
    private var encoder_: QREncoder!
    private var correctionLevel_: QRConstants.CorrectionLevel!

    private var imageGenerator_: QRImageGenerator!

    private let textBox_ = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let sideSize = min(view.frame.width, view.frame.height)
        imageGenerator_ = SimpleQRImageGenerator(screenSideMinSize: sideSize)

        setupView()
    }

    func setup(encoder: QREncoder, correctionLevel: QRConstants.CorrectionLevel) {
        encoder_ = encoder
        correctionLevel_ = correctionLevel

        title = type(of: encoder).dataDesc
    }

    @objc private func generateQR_() {
        guard let data = textBox_.text else { return }

        do {
            let (qrData, version) = try encoder_.generateQRData(data, with: correctionLevel_)
            let qrImage = imageGenerator_.generateQRImage(
                qrData: qrData, correctionLevel: correctionLevel_, version: version
            )
            
            qrIsGenerated_(qrCode: qrImage)
        } catch EncoderError.tooMuchData {
            generationIsFailed_(
                message: "The data is too big to be encoded in QR code. Try to " +
                "reduce the data size or choose a lower level of error correction."
            )
        } catch EncoderError.dataIsEmpty {
            generationIsFailed_(message: "Enter the data to encode.")
        } catch EncoderError.uncorrectData(let desc) {
            generationIsFailed_(message: "The data contains invalid characters: \(desc)")
        } catch {
        }
    }

    private func qrIsGenerated_(qrCode: UIImage) {
        let presenter = QRPresentingViewController()
        presenter.setup(show: qrCode)

        navigationController?.pushViewController(presenter, animated: true)
    }

    private func generationIsFailed_(message: String) {
        let alert = UIAlertController(title: "Generation error", message: message,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))

        present(alert, animated: true)
    }
}

//MARK: - Appearance functions
private extension QRGeneratingViewController {
    func setupView() {
        let label = UILabel()
        let button = UIButton()

        label.text = "Enter the data:"
        label.font = UIFont.systemFont(ofSize: 28)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .natural

        textBox_.font = UIFont.systemFont(ofSize: 20)
        textBox_.layer.cornerRadius = 5
        textBox_.layer.borderWidth = 1
        textBox_.layer.borderColor = UIColor.black.cgColor

        button.setTitle("Сonfirm", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(generateQR_), for: .touchUpInside)

        view.addSubview(label)
        view.addSubview(textBox_)
        view.addSubview(button)

        setupConstraints(label: label, textBox: textBox_, button: button)
    }

    func setupConstraints(label: UILabel, textBox: UITextView, button: UIButton) {
        label.translatesAutoresizingMaskIntoConstraints = false
        textBox.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            label.widthAnchor.constraint(equalTo: safe.widthAnchor, multiplier: 0.9),
            label.topAnchor.constraint(equalTo: safe.topAnchor),

            textBox.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            textBox.widthAnchor.constraint(equalTo: safe.widthAnchor, multiplier: 0.9),
            textBox.heightAnchor.constraint(equalTo: safe.heightAnchor, multiplier: 0.4),
            textBox.topAnchor.constraint(equalToSystemSpacingBelow: label.bottomAnchor, multiplier: 1),

            button.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            button.widthAnchor.constraint(equalTo: safe.widthAnchor, multiplier: 0.8),
            button.topAnchor.constraint(equalTo: textBox.bottomAnchor, constant: 20)
        ])
    }
}
