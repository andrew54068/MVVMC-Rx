//
//  LoadingViewable.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/18.
//  Copyright © 2020 andrew. All rights reserved.
//

import UIKit

protocol LoadingViewable: AnyObject {
    func startAnimating()
    func stopAnimating()
}

private var activityAssociatedObjectKey: Void?

extension LoadingViewable where Self : UIViewController {

    var storedActivityView: UIActivityIndicatorView? {
        get { return objc_getAssociatedObject(self, &activityAssociatedObjectKey) as? UIActivityIndicatorView }
        set { objc_setAssociatedObject(self, &activityAssociatedObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func startAnimating(){
        let activityView: UIActivityIndicatorView
        if let view: UIActivityIndicatorView = storedActivityView {
            activityView = view
        } else {
            let view = UIActivityIndicatorView(frame: .init(x: 0, y: 0, width: 50, height: 50))
            storedActivityView = view
            activityView = view
        }
        view.addSubview(activityView)
        activityView.center = view.center
        view.bringSubviewToFront(activityView)
        activityView.startAnimating()
    }

    func stopAnimating() {
        storedActivityView?.stopAnimating()
        storedActivityView?.removeFromSuperview()
    }
    
}
