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
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window: UIWindow = .init()
        self.window = window
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
        return true
    }

}

protocol Coordinator: AnyObject {
    func start()
}

enum CoordinatorKey: String {
    case collectionList
    case collectionDetail
}

final class AppCoordinator: Coordinator {

    var coordinators: [CoordinatorKey: Coordinator] = .init()

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        window.makeKeyAndVisible()
        showList(owner: "0x960DE9907A2e2f5363646d48D7FB675Cd2892e91")
    }


    // MARK: - show collection list
    func showList(owner: String) {
        let listCoodinator: CollectionListCoordinator = CollectionListCoordinator(window: window, owner: owner)
        coordinators[.collectionList] = listCoodinator
        listCoodinator.delegate = self
        listCoodinator.start()

        // make sure rootViewController isn't nil
        assert(self.window.rootViewController != nil)
    }

}

extension AppCoordinator: CollectionListCoordinatorDelegate {

    func CollectionListCoordinatorDidFinish(listCoordinator: CollectionListCoordinator) {
        coordinators[.collectionList] = nil
    }

}
