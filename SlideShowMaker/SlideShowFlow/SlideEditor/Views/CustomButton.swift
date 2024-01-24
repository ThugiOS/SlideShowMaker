//
//  CustomButton.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 24.01.24.
//

import SnapKit
import UIKit

class CustomButton: UIView {
    private lazy var imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "buttonField"))
//        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    private let fontSize: CGFloat
    private let buttonText: String

    init(text: String, fontSize: CGFloat) {
        self.buttonText = text
        self.fontSize = fontSize
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        label.frame = bounds
    }

    private func setupViews() {
        addSubview(imageView)
        addSubview(label)

        label.text = buttonText
        label.font = UIFont(name: "Gilroy-SemiBold", size: CGFloat(fontSize))
    }

    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
}
