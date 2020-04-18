//
//  AppDelegate.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/17.
//  Copyright © 2020 andrew. All rights reserved.
//

import UIKit
import SDWebImageSVGKitPlugin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window: UIWindow = .init()
        self.window = window
        let coordinator: AppCoordinator = AppCoordinator()
        window.rootViewController = coordinator.start()
        window.makeKeyAndVisible()
        return true
    }

    private func setupSVGDecoder() {
        let svgCoder = SDImageSVGKCoder.shared
        SDImageCodersManager.shared.addCoder(svgCoder)
    }

}
