//
//  CustomLabel.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 24.01.24.
//

import UIKit

final class CustomLabel: UILabel {
    enum FontType {
        case medium
        case semiBold
        case bold
    }

    init(title: String?, size: Int, alpha: Double, fontType: FontType) {
        super.init(frame: .zero)

        self.text = title
        self.textColor = .labelBlack.withAlphaComponent(alpha)

        switch fontType {
        case .medium:
            self.font = UIFont.gilroyMedium(ofSize: CGFloat(size))

        case .semiBold:
            self.font = UIFont.gilroySemiBold(ofSize: CGFloat(size))

        case .bold:
            self.font = UIFont.gilroyBold(ofSize: CGFloat(size))
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
