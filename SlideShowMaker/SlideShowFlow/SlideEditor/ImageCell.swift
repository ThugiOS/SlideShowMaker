//
//  ImageCell.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 14.12.23.
//

import UIKit

class MyCell: UICollectionViewCell {
    static let identifier = "CustomCell"

    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    public func configure(with image: UIImage) {
        self.myImageView.image = image
        setupUI()
    }

    private func setupUI() {
        self.addSubview(myImageView)

        NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: self.topAnchor),
            myImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            myImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            myImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.myImageView.image = nil
    }
}
