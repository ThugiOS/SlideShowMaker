//
//  GradientButton.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 29.05.24.
//

// import UIKit
//
// final class AnimatedGradientButton: UIButton {
//    private let gradientLayer = CAGradientLayer()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupButton()
//    }
//
//    @available(*, unavailable)
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupButton()
//    }
//
//    private func setupButton() {
//        gradientLayer.colors = [UIColor.butoon2.cgColor, UIColor.button1.cgColor]
//
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 0.1, y: 0.7)
//
//        layer.insertSublayer(gradientLayer, at: 0)
//        startAnimatingGradient()
//    }
//
//    private func startAnimatingGradient() {
//        let animation = CABasicAnimation(keyPath: "colors")
//        animation.fromValue = gradientLayer.colors
//        animation.toValue = [UIColor.button1.cgColor, UIColor.butoon2.cgColor]
//        animation.duration = 3
//        animation.autoreverses = true
//        animation.repeatCount = Float.infinity
//        gradientLayer.add(animation, forKey: "colorChange")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        gradientLayer.frame = bounds
//    }
//
//    func restartAnimation() {
//        gradientLayer.removeAllAnimations()
//        startAnimatingGradient()
//    }
// }

import SnapKit
import UIKit

final class AnimatedGradientButton: UIButton {
    private let gradientLayer = CAGradientLayer()
    private let customImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    private func setupButton() {
        // Настройка градиента
        gradientLayer.colors = [UIColor.butoon2.cgColor, UIColor.button1.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.1, y: 0.7)
        layer.insertSublayer(gradientLayer, at: 0)
        startAnimatingGradient()

        // Настройка изображения
        setupImageView()
    }

    private func setupImageView() {
        // Настройка изображения
        customImageView.contentMode = .scaleAspectFit
        customImageView.tintColor = .white
//        customImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(customImageView)

        customImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.height.width.equalTo(35)
        }
        // Установка ограничений для imageView
//        NSLayoutConstraint.activate([
//            customImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            customImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
//            customImageView.widthAnchor.constraint(equalToConstant: 20), // Установите необходимую ширину
//            customImageView.heightAnchor.constraint(equalToConstant: 20) // Установите необходимую высоту
//        ])
    }

    func setImage(_ image: UIImage?) {
        customImageView.image = image
    }

    private func startAnimatingGradient() {
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = gradientLayer.colors
        animation.toValue = [UIColor.button1.cgColor, UIColor.butoon2.cgColor]
        animation.duration = 3
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        gradientLayer.add(animation, forKey: "colorChange")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    func restartAnimation() {
        gradientLayer.removeAllAnimations()
        startAnimatingGradient()
    }
}
