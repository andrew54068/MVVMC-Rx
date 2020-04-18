//
//  SVGProcessor.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/18.
//  Copyright © 2020 andrew. All rights reserved.
//

import Kingfisher

struct SVGProcessor: ImageProcessor {

    static let `default`: SVGProcessor = SVGProcessor(CGSize(width: 600, height: 600))

    var size = CGSize(width: 320, height: 320)

    init(_ size: CGSize) {
        if size.width == 0 || size.height == 0 {
            print("不支持size为0的情况m，将采用默认值32")
        } else {
            self.size = size
        }
    }

    let identifier: String = "com.wegene.future"

    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
//        return nil
        switch item {
        case .image(let image):
//            print("already an image")
            return image
        case .data(let data):
//            KingfisherWrapper.image(data: data, options: options.imageCreatingOptions)
//            let view = UIView(SVGData: data)
//            let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
//            return renderer.image { context in
//                view.layer.render(in: context.cgContext)
//            }

//            let svgContent = String.init(data: data, encoding: String.Encoding.utf8)
//            var img: UIImage?
//            DispatchQueue.main.sync {
//                //现在Macaw库暂时只支持这种方式生成UIImage,下一版他们支持后台线程生成UIImage的方式，以后再做修改
//                let rootNode = try! SVGParser.parse(text: svgContent!)
//                let macawView = MacawView(node: rootNode, frame:CGRect(origin: CGPoint.zero, size: size))
//                UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
//                macawView.layer.render(in: UIGraphicsGetCurrentContext()!)
//                img = UIGraphicsGetImageFromCurrentImageContext();
//                UIGraphicsEndImageContext();
//            }
            return UIImage()
        }
    }
}
