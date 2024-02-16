//
//  OnboardingCollectionViewCell.swift
//  Onboarding
//
//  Created by Никитин Артем on 15.02.24.
//

import Foundation
import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: OnboardingCollectionViewCell.self)

    lazy var slideImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    lazy var slideTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.gilroyBold(ofSize: CGFloat(38))
        label.textColor = .labelBlack
        return label
    }()

    lazy var slideDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.gilroyMedium(ofSize: CGFloat(14))
        label.textColor = .labelBlack
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
        addSubview(slideImageView)
        addSubview(slideTitleLabel)
        addSubview(slideDescriptionLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        slideImageView.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
        }

        slideTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(slideImageView.snp.bottom)
        }

        slideDescriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(slideTitleLabel.snp.bottom).offset(10)
        }
    }

    func setup(_ slide: OnboardingSlide) {
        slideImageView.image = slide.image
        slideTitleLabel.text = slide.title
        slideDescriptionLabel.text = slide.description
    }
}
