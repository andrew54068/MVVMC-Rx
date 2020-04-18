//
//  UIImageExtension.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/18.
//  Copyright © 2020 andrew. All rights reserved.
//

import UIKit

extension UIImageView {
    func setSvgImage(_ url: String) {
        let processor = SVGProcessor(self.frame.size)
        let _url = URL(string: url)
        self.kf.setImage(with: _url, options:[.processor(processor)])
    }
}
