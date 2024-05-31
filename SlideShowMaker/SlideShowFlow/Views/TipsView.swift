//
//  TipsView.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 30.05.24.
//

import SnapKit
import UIKit

final class TipsView: UIView {
    private let titleLabel1 = UILabel()
    private let imageView1 = UIImageView()

    private let titleLabel2 = UILabel()
    private let imageView2 = UIImageView()

    private let titleLabel3 = UILabel()
    private let imageView3 = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let imageAlpha = 0.4
        let textColor = UIColor.darkGray

        imageView1.image = UIImage(named: "resolution")
        imageView2.image = UIImage(named: "timer")
        imageView3.image = UIImage(named: "rectangle")

        imageView1.alpha = imageAlpha
        imageView2.alpha = imageAlpha
        imageView3.alpha = imageAlpha

        titleLabel1.text = String(localized: "Click to change aspect ratio")
        titleLabel2.text = String(localized: "Click to change speed")
        titleLabel3.text = String(localized: "Click to add an image")

        titleLabel1.textColor = textColor
        titleLabel2.textColor = textColor
        titleLabel3.textColor = textColor

        addSubview(titleLabel1)
        addSubview(imageView1)

        addSubview(titleLabel2)
        addSubview(imageView2)

        addSubview(titleLabel3)
        addSubview(imageView3)

        setupConstraints()
    }

    private func setupConstraints() {
        imageView1.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.height.equalTo(35)
        }

        titleLabel1.snp.makeConstraints { make in
            make.centerY.equalTo(imageView1)
            make.leading.equalTo(imageView1.snp.trailing).offset(20)
        }

        imageView2.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.height.equalTo(35)
            make.top.equalTo(imageView1.snp.bottom).offset(20)
        }

        titleLabel2.snp.makeConstraints { make in
            make.centerY.equalTo(imageView2)
            make.leading.equalTo(imageView2.snp.trailing).offset(20)
        }

        imageView3.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.height.equalTo(35)
            make.top.equalTo(imageView2.snp.bottom).offset(20)
        }

        titleLabel3.snp.makeConstraints { make in
            make.centerY.equalTo(imageView3)
            make.leading.equalTo(imageView3.snp.trailing).offset(20).offset(20)
        }
    }
}
