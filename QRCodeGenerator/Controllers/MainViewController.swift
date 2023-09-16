//
//  MainViewController.swift
//  QRCodeGenerator
//
//  Created by Евгений Кацер on 07.09.2023.
//

import UIKit

class MainViewController: UIViewController {
    private let qrEncoders_: [QREncoder] = [
        NumsQREncoder(),
        LettersAndNumsQREncoder(),
    ]

    private var activeEncoder_: QREncoder!
    private var correctionLevel_: QRConstants.CorrectionLevel!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupView()
    }

    @objc private func encoderIsSelected_() {
        let qrGenerating = QRGeneratingViewController()
        qrGenerating.setup(encoder: activeEncoder_, correctionLevel: correctionLevel_)

        navigationController?.pushViewController(qrGenerating, animated: true)
    }
}

//MARK: - Appearance functions
private extension MainViewController {
    func setupView() {
        let label = UILabel()
        let picker = UIPickerView()
        let button = UIButton()

        label.text = "Pick a type of data to code in QR"
        label.font = UIFont.systemFont(ofSize: 28)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center

        picker.dataSource = self
        picker.delegate = self

        button.setTitle("Сonfirm", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(encoderIsSelected_), for: .touchUpInside)

        view.addSubview(label)
        view.addSubview(picker)
        view.addSubview(button)

        setupConstraints_(label: label, picker: picker, button: button)
    }

    func setupConstraints_(label: UILabel, picker: UIPickerView, button: UIButton) {
        label.translatesAutoresizingMaskIntoConstraints = false
        picker.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: safe.topAnchor, constant: 40),
            label.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            label.widthAnchor.constraint(lessThanOrEqualTo: safe.widthAnchor, multiplier: 0.8),

            picker.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40),
            picker.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            picker.widthAnchor.constraint(equalTo: safe.widthAnchor),

            button.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -20),
            button.widthAnchor.constraint(equalTo: safe.widthAnchor, multiplier: 0.8),
        ])
    }
}

//MARK: - UIPickerViewDataSource
extension MainViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return qrEncoders_.count
        } else {
            return QRConstants.correctionLevels.count
        }

    }
}

//MARK: - UIPickerViewDelegate methods
extension MainViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            activeEncoder_ = qrEncoders_[row]
            return type(of: activeEncoder_).dataDesc
        } else {
            correctionLevel_ = QRConstants.correctionLevels[row]
            return correctionLevel_.getDesc()
        }
    }
}
