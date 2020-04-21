//
//  CollectionListFooter.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/20.
//  Copyright © 2020 andrew. All rights reserved.
//

import UIKit
import SnapKit

class CollectionListFooter: UICollectionReusableView {

    private let activityIndicator: UIActivityIndicatorView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        activityIndicator.startAnimating()
    }

}
