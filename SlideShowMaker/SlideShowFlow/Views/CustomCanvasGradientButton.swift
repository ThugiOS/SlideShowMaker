//
//  CustomCanvasGradientButton.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 25.01.24.
//

import UIKit

class CustomCanvasGradientButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)

        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.gilroyMedium(ofSize: 17)

        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor(hex: 0x5F81FE).cgColor, UIColor(hex: 0x35AEFC).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.first?.frame = bounds
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: alpha
        )
    }
}
