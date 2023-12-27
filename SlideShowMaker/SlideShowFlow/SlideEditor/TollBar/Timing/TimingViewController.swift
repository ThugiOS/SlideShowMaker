//
//  TimingViewController.swift
//  ToolBar
//
//  Created by Никитин Артем on 26.12.23.
//

import SnapKit
import UIKit

class TimingViewController: UIViewController {
    private let buttonDone: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.backgroundColor = .grayForDemo
        button.tintColor = .white
        button.setTitle("Done", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(buttonDone)

        buttonDone.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }

    @objc
    func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension TimingViewController {
    private func setConstraints() {
        buttonDone.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-25)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
}
