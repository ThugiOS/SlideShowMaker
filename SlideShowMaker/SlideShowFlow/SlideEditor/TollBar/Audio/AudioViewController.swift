//
//  AudioViewController.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 26.12.23.
//

import SnapKit
import UIKit

class AudioViewController: UIViewController {
    private let buttonDone: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.backgroundColor = .grayForDemo
        button.tintColor = .white
        button.setTitle("Done", for: .normal)
        return button
    }()

    private let nameScreenLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayForDemo
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.text = "Audio"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground

        view.addSubview(nameScreenLabel)
        view.addSubview(buttonDone)

        buttonDone.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }

    @objc
    func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension AudioViewController {
    private func setConstraints() {
        nameScreenLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }

        buttonDone.snp.makeConstraints { make in
            make.centerY.equalTo(nameScreenLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
}
