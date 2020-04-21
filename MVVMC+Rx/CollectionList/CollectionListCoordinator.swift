//
//  CollectionListCoordinator.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/17.
//  Copyright © 2020 andrew. All rights reserved.
//

import UIKit
import RxSwift

protocol CollectionListCoordinatorProtocol: AnyObject {
    var navigator: UINavigationController? { get set }
    func navigate(with model: CollectionModel)
}

final class CollectionListCoordinator: CollectionListCoordinatorProtocol {

    weak var navigator: UINavigationController?

    func navigate(with model: CollectionModel) {
        // Preparing the new calçot
        let detailCoordinator = CollectionDetailCoordinator(navigator: navigator)
        let detailInteractor = CollectionDetailInteractor(model: model)
        let detailViewModel = CollectionDetailViewModel(interactor: detailInteractor,
                                                        coordinator: detailCoordinator,
                                                        model: model)
        let detailViewController = CollectionDetailViewController(viewModel: detailViewModel)

        navigator?.pushViewController(detailViewController, animated: true)
        detailViewModel.modelSubject.onNext(model)
    }

}
