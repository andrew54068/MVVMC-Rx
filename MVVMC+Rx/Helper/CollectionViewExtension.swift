//
//  CollectionViewExtension.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/18.
//  Copyright © 2020 andrew. All rights reserved.
//

import UIKit

extension UICollectionView {

    func registerCell<T: UICollectionViewCell>(type: T.Type) {
        register(type,
                 forCellWithReuseIdentifier: String(describing: type))
    }

    func registerSectionFooter<T: UICollectionReusableView>(type: T.Type) {
        register(type, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: type))
    }

    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: type),
                                   for: indexPath) as! T
    }

    func dequeueReusableSectionFooter<T: UICollectionReusableView>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: type), for: indexPath) as! T
    }

}
