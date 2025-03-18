//
//  SaveToLibrary.swift
//  SlideMixer
//
//  Created by Никитин Артем on 14.03.25.
//

import SnapKit
import UIKit

final class SaveToLibrary: UIView {
    var onCancelSaveToLibrary: (() -> Void)?
    var onSaveToLibrary: (() -> Void)?

    private let mainlabel: UILabel = {
        $0.text = String(localized: "The video has been saved to the gallery")
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        return $0
    }(UILabel())

    private let descriptionlabel: UILabel = {
        $0.text = String(localized: "Save project to library?")
        $0.font = .systemFont(ofSize: 15, weight: .light)
        $0.textColor = .lightGray
        $0.textAlignment = .center
        return $0
    }(UILabel())

    private let buttonCancel: UIButton = {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .gray
        $0.tintColor = .white
        $0.setTitle(String(localized: "No"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return $0
    }(UIButton())

    private let buttonSave: AnimatedGradientButton = {
        let button = AnimatedGradientButton()
        button.setTitle(String(localized: "Save project"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupActions() {
        buttonCancel.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        buttonSave.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }

    private func setupUI() {
        self.backgroundColor = .black.withAlphaComponent(0.7)
        self.layer.cornerRadius = 20

        self.addSubview(mainlabel)
        self.addSubview(descriptionlabel)
        self.addSubview(buttonCancel)
        self.addSubview(buttonSave)

        mainlabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
        }

        descriptionlabel.snp.makeConstraints { make in
            make.top.equalTo(mainlabel.snp.bottom)
            make.centerX.equalToSuperview()
        }

        buttonCancel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(20)
            make.width.equalTo(120)
            make.height.equalTo(44)
        }

        buttonSave.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(20)
            make.width.equalTo(120)
            make.height.equalTo(44)
        }
    }

    // MARK: - Actions
    @objc
    private func cancelTapped() {
        removeFromSuperview()
        onCancelSaveToLibrary?()
    }

    @objc
    private func saveTapped() {
        self.buttonSave.setTitle(String(localized: "Saving..."), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.onSaveToLibrary?()
            self.removeFromSuperview()
        }
    }

    func showSaveProjectAlert(in parentView: UIView) {
        parentView.addSubview(self)

        self.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(170)
        }
    }
}
