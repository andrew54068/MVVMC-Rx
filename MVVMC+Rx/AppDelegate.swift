//
//  AppDelegate.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/17.
//  Copyright © 2020 andrew. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

}

protocol Coordinator: AnyObject {
    func start()
}

enum CoordinatorKey: String {
    case collection
    case collectionDetail
}

final class AppCoordinator: Coordinator {

    var coordinators: [CoordinatorKey: Coordinator] = .init()

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        
    }

}

