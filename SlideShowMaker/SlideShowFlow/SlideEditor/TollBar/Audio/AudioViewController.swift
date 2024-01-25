//
//  AudioViewController.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 26.12.23.
//

import SnapKit
import UIKit

final class AudioViewController: UIViewController {
    private let buttonDone = CustomButton(text: String(localized: "Done"), fontSize: 20)
    private let nameScreenLabel = CustomLabel(title: String(localized: "Audio"), size: 22, alpha: 1, fontType: .bold)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground

        view.addSubview(nameScreenLabel)
        view.addSubview(buttonDone)

        let tapDoneButton = UITapGestureRecognizer(target: self, action: #selector(doneButtonTapped))
        buttonDone.addGestureRecognizer(tapDoneButton)
    }

    @objc
    func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

private extension AudioViewController {
    func setConstraints() {
        nameScreenLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }

        buttonDone.snp.makeConstraints { make in
            make.centerY.equalTo(nameScreenLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(91)
            make.height.equalTo(43)
        }
    }
}
