//
//  CollectionListCoordinator.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/17.
//  Copyright © 2020 andrew. All rights reserved.
//

import UIKit

protocol CollectionListCoordinatorDelegate: AnyObject {

    func CollectionListCoordinatorDidFinish(listCoordinator: CollectionListCoordinator)

}

final class CollectionListCoordinator: Coordinator {

    weak var delegate: CollectionListCoordinatorDelegate?

    private let window: UIWindow
    private lazy var navigator: UINavigationController = UINavigationController(rootViewController: listViewController)
    private let listViewController: CollectionListViewController

    init(window: UIWindow, owner: String) {
        self.window = window
        let interactor: CollectionListInteractor = CollectionListInteractor(owner: owner,
                                                                            dataProvider: DataProvider.shared)
        // TODO: need to replace with detailCoordinator
        let coordinator: CollectionListCoordinator = CollectionListCoordinator(window: window, owner: owner)
        let viewModel: CollectionListViewModel = .init(interactor: interactor, coordinator: coordinator)
        listViewController = CollectionListViewController(viewModel: viewModel)
    }

    func start() {
        window.rootViewController = navigator
    }

}
