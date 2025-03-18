//
//  ArchiveCell.swift
//  SlideMixer
//
//  Created by Никитин Артем on 3.06.24.
//

import Foundation
import UIKit

final class ArchiveCell: UICollectionViewCell {
    static let identifier = String(describing: ArchiveCell.self)
    var returnToMainCollectionHandler: (() -> Void)?

    private let backView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private let firstProjectImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameProjectLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.alpha = 0.5
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        return label
    }()

    private let returnToMainCollectionButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "shippingbox.and.arrow.backward.fill")
        configuration.imagePadding = 10

        configuration.imagePlacement = .leading
        configuration.image?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))

        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.layer.cornerRadius = 10
        button.backgroundColor = .clear
        button.tintColor = .white

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addShadow()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupUI() {
        self.addSubview(backView)
        backView.addSubview(firstProjectImage)
        self.addSubview(dateLabel)
        self.addSubview(nameProjectLabel)
        self.addSubview(returnToMainCollectionButton)

        returnToMainCollectionButton.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)

        backView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }

        firstProjectImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(backView)
            make.bottom.equalTo(backView).offset(-81)
        }

        nameProjectLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalTo(dateLabel.snp.top)
        }

        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-15)
        }

        returnToMainCollectionButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().offset(-20)
            make.width.height.equalTo(44)
        }
    }

    private func addShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 10

        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    public func configureProjectCell(image: UIImage, date: String, projectName: String) {
        self.firstProjectImage.image = image
        self.dateLabel.text = date
        self.nameProjectLabel.text = projectName
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.firstProjectImage.image = nil
        self.dateLabel.text = nil
        self.nameProjectLabel.text = nil
    }

    @objc
    private func returnButtonTapped() {
        returnToMainCollectionHandler?()
    }
}
