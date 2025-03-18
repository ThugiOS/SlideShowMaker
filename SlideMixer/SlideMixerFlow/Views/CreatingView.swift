//
//  CreatingView.swift
//  SlideMixer
//
//  Created by Никитин Артем on 14.03.25.
//

import Lottie
import SnapKit
import UIKit

final class CreatingView: UIView {
    private let bluer: CustomBlurEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = CustomBlurEffectView(effect: blurEffect, fractionComplete: 0.3)
        return blurView
    }()

    private let lottieView: LottieAnimationView = {
        let lottie = LottieAnimationView(name: "8")
        lottie.contentMode = .scaleAspectFill
        lottie.loopMode = .loop
        lottie.animationSpeed = 0.6
        return lottie
    }()

    private let mainLabel: UILabel = {
        $0.text = String(localized: "Creating video ...")
        $0.font = .systemFont(ofSize: 28, weight: .heavy)
        $0.textColor = .white
        $0.textAlignment = .center
        return $0
    }(UILabel())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        lottieView.play()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(bluer)
        addSubview(lottieView)
        addSubview(mainLabel)

        bluer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        lottieView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(400)
        }

        mainLabel.snp.makeConstraints {
            $0.centerX.equalTo(lottieView)
            $0.top.equalTo(lottieView.snp.bottom).offset(-70)
        }
    }
}
