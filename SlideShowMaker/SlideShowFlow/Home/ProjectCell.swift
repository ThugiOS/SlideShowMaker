//
//  ProjectCell.swift
//  SlideShowMaker
//
//  Created by Никитин Артем on 14.03.24.
//

import Foundation
import UIKit

final class ProjectCell: UICollectionViewCell {
    static let identifier = String(describing: ProjectCell.self)

    private let backView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private let firstProjectImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameProjectLabel: UILabel = {
        let label = UILabel()
        label.textColor = .labelBlack
        label.textAlignment = .center
        label.font = UIFont.gilroyBold(ofSize: 24)
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .labelBlack
        label.alpha = 0.5
        label.textAlignment = .center
        label.font = UIFont.gilroyMedium(ofSize: 14)

        return label
    }()

    private let contextMenuView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "contextMenu")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addShadow()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        addShadow()
    }

    private func setupUI() {
        self.addSubview(backView)
        backView.addSubview(firstProjectImage)
        self.addSubview(dateLabel)
        self.addSubview(nameProjectLabel)
        self.addSubview(contextMenuView)

        backView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }

        firstProjectImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(backView)
            make.bottom.equalTo(backView).offset(-81)
        }

        nameProjectLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalTo(dateLabel.snp.top)
        }

        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-15)
        }

        contextMenuView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().offset(-25)
            make.width.height.equalTo(29)
        }
    }

    private func addShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 10

        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    public func configureProjectCell(image: UIImage, date: String, projectName: String) {
        self.firstProjectImage.image = image
        self.dateLabel.text = date
        self.nameProjectLabel.text = projectName
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.firstProjectImage.image = nil
        self.dateLabel.text = nil
        self.nameProjectLabel.text = nil
    }
}
