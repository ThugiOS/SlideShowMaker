//
//  ImageCell.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 14.12.23.
//

import SnapKit
import UIKit
//
// final class ImageCell: UICollectionViewCell {
//    static let identifier = "CustomCell"
//
//    private let myImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 15
//        imageView.layer.borderWidth = 0
//        return imageView
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupUI()
//    }
//
//    private func setupUI() {
//        self.addSubview(myImageView)
//
//        myImageView.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//        }
//    }
//
//    public func configure(with image: UIImage) {
//        self.myImageView.image = image
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.myImageView.image = nil
//    }
// }

final class ImageCell: UICollectionViewCell {
    static let identifier = "CustomCell"

    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        self.addSubview(myImageView)

        myImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }

    public func configure(with image: UIImage, isSelected: Bool, hasSelectedImage: Bool) {
        self.myImageView.image = image

        if isSelected && hasSelectedImage {
            self.myImageView.layer.borderWidth = 3.0
            self.myImageView.layer.borderColor = UIColor.red.cgColor
        }
        else {
            self.myImageView.layer.borderWidth = 0.0
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.myImageView.image = nil
        self.myImageView.layer.borderWidth = 0.0
    }
}
