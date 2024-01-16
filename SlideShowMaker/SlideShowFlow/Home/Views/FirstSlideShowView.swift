//
//  FirstSlideShowView.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 15.01.24.

 import SnapKit
 import UIKit

 final class FirstSlideShowView: UIView {
    private let firstSlideShowView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "firstSlideShowProject")
        return imageView
    }()

    private let indexFingerView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "indexFinger")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainer()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupContainer()
        setConstraints()
    }

    private func setupContainer() {
        addSubview(firstSlideShowView)
        addSubview(indexFingerView)

        animateIndexFingerView()
    }

     private func animateIndexFingerView() {
         UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse, .repeat]) {
             self.indexFingerView.transform = CGAffineTransform(translationX: 0, y: -15)
         }
     }
 }

extension FirstSlideShowView {
    private func setConstraints() {
        firstSlideShowView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
        }

        indexFingerView.snp.makeConstraints { make in
            make.width.height.equalToSuperview().dividedBy(12)
            make.bottom.equalToSuperview().inset(10)
            make.centerX.equalTo(firstSlideShowView.snp.centerX)
        }
    }
}
