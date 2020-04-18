//
//  AppCoordinator.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/19.
//  Copyright © 2020 andrew. All rights reserved.
//

import UIKit

final class AppCoordinator {

    func start() -> UINavigationController {
        return showList(owner: "0x960DE9907A2e2f5363646d48D7FB675Cd2892e91")
    }

    // MARK: - show collection list
    private func showList(owner: String) -> UINavigationController {
        let coordinator: CollectionListCoordinator = CollectionListCoordinator()
        let interactor: CollectionListInteractor = CollectionListInteractor(owner: owner,
                                                                            dataProvider: DataProvider.shared)
        let viewModel: CollectionListViewModel = .init(interactor: interactor, coordinator: coordinator)

        let listViewController = CollectionListViewController(viewModel: viewModel)
        let navigationController: UINavigationController = .init(rootViewController: listViewController)
        coordinator.navigator = navigationController
        return navigationController
    }

}
