//
//  ImageCell.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 14.12.23.
//

import SnapKit
import UIKit

final class ImageCell: UICollectionViewCell {
    static let identifier = "CustomCell"

    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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

    public func configure(with image: UIImage) {
        self.myImageView.image = image
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.myImageView.image = nil
    }
}
