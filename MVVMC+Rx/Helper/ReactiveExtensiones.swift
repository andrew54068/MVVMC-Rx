//
//  ReactiveExtensiones.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/18.
//  Copyright © 2020 andrew. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension UIViewController: LoadingViewable {}

extension Reactive where Base: UIViewController {

    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isLoading: Binder<Bool> {
        return Binder(self.base, binding: { (vc, active) in
            if active {
                vc.startAnimating()
            } else {
                vc.stopAnimating()
            }
        })
    }

}
