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
        showList()
    }


    // MARK: - show collection list
    func showList() {
        let listCoodinator: CollectionListCoordinator = CollectionListCoordinator(window: self.window)
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

protocol CollectionListCoordinatorDelegate: AnyObject {

    func CollectionListCoordinatorDidFinish(listCoordinator: CollectionListCoordinator)

}

final class CollectionListCoordinator: Coordinator {

    weak var delegate: CollectionListCoordinatorDelegate?

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        window.rootViewController = CollectionListViewController()
    }

}

final class CollectionListViewController: UIViewController {

}
