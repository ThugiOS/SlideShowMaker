//
//  GradientButton.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 25.01.24.
//

//import UIKit
//
//class CustomGradientButton: UIButton {
//    enum FontSize {
//        case big
//        case medium
//        case small
//    }
//
//    init(title: String, hasBackground: Bool = false, fontSize: FontSize) {
//        super.init(frame: .zero)
//
//        self.setTitle(title, for: .normal)
//        self.layer.cornerRadius = 12
//        self.layer.masksToBounds = true
//
//        if hasBackground {
//            // Создаем градиент для кнопки с фоном
//            let gradientLayer = CAGradientLayer()
//            gradientLayer.frame = bounds
//            gradientLayer.colors = [UIColor(hex: 0x5F81FE).cgColor, UIColor(hex: 0x35AEFC).cgColor]
//            gradientLayer.locations = [0.0, 1.0]
//            layer.insertSublayer(gradientLayer, at: 0)
//        }
//        else {
//            self.backgroundColor = .clear
//        }
//
//        let titleColor: UIColor = hasBackground ? .white : .systemCyan
//        self.setTitleColor(titleColor, for: .normal)
//
//        switch fontSize {
//        case .big:
//            self.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
//
//        case .medium:
//            self.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
//
//        case .small:
//            self.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
//        }
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        // Обновляем размер и положение градиентного слоя при изменении размеров кнопки
//        layer.sublayers?.first?.frame = bounds
//    }
//}
//
//extension UIColor {
//    convenience init(hex: Int, alpha: CGFloat = 1.0) {
//        self.init(
//            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
//            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
//            blue: CGFloat(hex & 0xFF) / 255.0,
//            alpha: alpha
//        )
//    }
//}


import UIKit

class CustomGradientButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)

        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont(name: "Gilroy-Medium", size: 17)
        
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor(hex: 0x5F81FE).cgColor, UIColor(hex: 0x35AEFC).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
    }

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

//UIFont(name: "Gilroy-Medium", size: CGFloat(10))
