//
//  OnboardingCollectionViewCell.swift
//  Onboarding
//
//  Created by Никитин Артем on 15.02.24.
//

import Foundation
import UIKit

final class OnboardingCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: OnboardingCollectionViewCell.self)

    lazy var slideImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var slideTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 38, weight: .bold)
        label.textColor = .white
        return label
    }()

    lazy var slideDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.alpha = 0.5
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .mainBackground
        addSubview(slideImageView)
        addSubview(slideTitleLabel)
        addSubview(slideDescriptionLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        slideImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.top.equalToSuperview().offset(-100)
        }

        slideTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(slideImageView.snp.bottom).offset(-150)
        }

        slideDescriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(slideTitleLabel.snp.bottom).offset(10)
        }
    }

    func configureOnboardingCell(_ slide: OnboardingSlide) {
        slideImageView.image = slide.image
        slideTitleLabel.text = slide.title
        slideDescriptionLabel.text = slide.description
    }
}
