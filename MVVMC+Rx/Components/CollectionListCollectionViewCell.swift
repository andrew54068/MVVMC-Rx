//
//  CollectionListCollectionViewCell.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/18.
//  Copyright © 2020 andrew. All rights reserved.
//

import UIKit
import Kingfisher

final class CollectionListCollectionViewCell: UICollectionViewCell {

    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.addSubview(itemImageView)
        contentView.addSubview(nameLabel)

        itemImageView.snp.makeConstraints { make in
            make.top.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-10)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.bottom).offset(10)
            make.left.equalTo(contentView).offset(10)
            make.bottom.right.equalTo(contentView).offset(-10)
        }
    }

    func setup(model: CollectionModel) {
        itemImageView.kf.setImage(with: model.imageUrl)
        nameLabel.text = model.name
    }
}
