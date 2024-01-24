//
//  CanvasViewController.swift
//  ToolBar
//
//  Created by Никитин Артем on 26.12.23.
//

import SnapKit
import UIKit

final class CanvasViewController: UIViewController {
    private let newButtonDone = CustomButton(text: "Done", fontSize: 20)

    private let buttonDone: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.backgroundColor = .gray
        button.tintColor = .white
        button.setTitle(String(localized: "Done"), for: .normal)
        return button
    }()

    private let nameScreenLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.text = String(localized: "Canvas")
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
        view.addSubview(newButtonDone)

        buttonDone.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doneButtonTapped))
        newButtonDone.addGestureRecognizer(tap)
    }

    @objc
    func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

private extension CanvasViewController {
    func setConstraints() {
        newButtonDone.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(50)
        }

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
