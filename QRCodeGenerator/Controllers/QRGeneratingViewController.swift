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
    private let button_ = UIButton()
    private let activityView_ = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let sideSize = min(view.frame.width, view.frame.height)
        imageGenerator_ = SimpleQRImageGenerator(screenSideMinSize: sideSize)

        setupView_()
        setupActivityView_()
    }

    func setup(encoder: QREncoder, correctionLevel: QRConstants.CorrectionLevel) {
        encoder_ = encoder
        correctionLevel_ = correctionLevel

        title = type(of: encoder).dataDesc
    }

    @objc private func generateButtonWasPressed_() {
        guard let data = textBox_.text else { return }

        showActivityViewController_()
        DispatchQueue.global().async { [self] in
            var errorMsg: String?, qrImage: UIImage!

            do {
                qrImage = try generateQR_(data: data)
            } catch EncoderError.tooMuchData {
                errorMsg = "The data is too big to be encoded in QR code. Try to " +
                "reduce the data size or choose a lower level of error correction."
            } catch EncoderError.dataIsEmpty {
                errorMsg = "Enter the data to encode."
            } catch EncoderError.uncorrectData(let desc) {
                errorMsg = "The data contains invalid characters: \(desc)"
            } catch {
                fatalError("Errors must be only EncoderError type!")
            }

            DispatchQueue.main.async { [self] in
                hideActivityViewController_()

                if let errorMsg {
                    generatingWasFailed_(message: errorMsg)
                } else {
                    generatingWasSucceed_(qrCode: qrImage)
                }
            }
        }
    }
}

//MARK: - Appearance functions
private extension QRGeneratingViewController {
    func setupView_() {
        let label = UILabel()
        label.text = "Enter the data:"
        label.font = UIFont.systemFont(ofSize: 28)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .natural

        textBox_.font = UIFont.systemFont(ofSize: 20)
        textBox_.layer.cornerRadius = 5
        textBox_.layer.borderWidth = 1
        textBox_.layer.borderColor = UIColor.black.cgColor

        button_.setTitle("Сonfirm", for: .normal)
        button_.setTitleColor(.black, for: .normal)
        button_.backgroundColor = .systemGray6
        button_.layer.cornerRadius = 6
        button_.addTarget(self, action: #selector(generateButtonWasPressed_), for: .touchUpInside)

        view.addSubview(label)
        view.addSubview(textBox_)
        view.addSubview(button_)

        setupConstraints_(label: label, textBox: textBox_, button: button_)
    }

    func setupConstraints_(label: UILabel, textBox: UITextView, button: UIButton) {
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

    func setupActivityView_() {
        activityView_.style = .large
        activityView_.color = .black
        activityView_.hidesWhenStopped = true

        view.addSubview(activityView_)
        setupActivityViewConstraints_()
    }

    func setupActivityViewConstraints_() {
        activityView_.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activityView_.centerXAnchor.constraint(equalTo: textBox_.centerXAnchor),
            activityView_.centerYAnchor.constraint(equalTo: textBox_.centerYAnchor)
        ])
    }
}

//MARK: - Methods to show and hide activityView_
private extension QRGeneratingViewController {
    func showActivityViewController_() {
        activityView_.startAnimating()
        textBox_.isEditable = false
        button_.isEnabled = false
    }

    func hideActivityViewController_() {
        activityView_.stopAnimating()
        textBox_.isEditable = true
        button_.isEnabled = true
    }
}

//MARK: - QR generating methods
private extension QRGeneratingViewController {
    func generateQR_(data: String) throws -> UIImage {
        let (qrData, version) = try encoder_.generateQRData(data, with: correctionLevel_)
        let qrCode = QRCodeGenerator.generateQRCode(
            qrData: qrData, correctionLevel: correctionLevel_, version: version
        )

        return imageGenerator_.generateQRImage(qrCode: qrCode)
    }

    private func generatingWasSucceed_(qrCode: UIImage) {
        let presenter = QRPresentingViewController()
        presenter.setup(show: qrCode)

        navigationController?.pushViewController(presenter, animated: true)
    }

    private func generatingWasFailed_(message: String) {
        let alert = UIAlertController(title: "Generation error", message: message,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))

        present(alert, animated: true)
    }
}
