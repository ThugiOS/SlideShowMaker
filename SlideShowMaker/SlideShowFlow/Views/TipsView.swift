//
//  TipsView.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 30.05.24.
//

import SnapKit
import UIKit

final class TipsView: UIView {
    // MARK: - Properties

    private let titleLabel1 = UILabel()
    private let imageView1 = UIImageView()

    private let titleLabel2 = UILabel()
    private let imageView2 = UIImageView()

    private let titleLabel3 = UILabel()
    private let imageView3 = UIImageView()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {
        // Configure labels
        titleLabel1.text = "Tip 1"
        titleLabel2.text = "Tip 2"
        titleLabel3.text = "Tip 3"

        // Configure images
        imageView1.image = UIImage(named: "tip1_image")
        imageView2.image = UIImage(named: "tip2_image")
        imageView3.image = UIImage(named: "tip3_image")

        // Add subviews
        addSubview(titleLabel1)
        addSubview(imageView1)

        addSubview(titleLabel2)
        addSubview(imageView2)

        addSubview(titleLabel3)
        addSubview(imageView3)

        // Setup constraints
        setupConstraints()
    }

    private func setupConstraints() {
        // First tip
        titleLabel1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        imageView1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel1.snp.bottom).offset(10)
            make.width.height.equalTo(100) // Adjust as needed
        }

        // Second tip
        titleLabel2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView1.snp.bottom).offset(20)
        }
        imageView2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel2.snp.bottom).offset(10)
            make.width.height.equalTo(100) // Adjust as needed
        }

        // Third tip
        titleLabel3.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView2.snp.bottom).offset(20)
        }
        imageView3.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel3.snp.bottom).offset(10)
            make.width.height.equalTo(100) // Adjust as needed
        }
    }
}
