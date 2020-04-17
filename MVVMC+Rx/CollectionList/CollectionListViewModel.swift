//
//  CollectionListViewModel.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/17.
//  Copyright © 2020 andrew. All rights reserved.
//

protocol CollectionListViewModelProtocol {
    var model: CollectionListModel? { get set }
    var interactor: CollectionListInteractor { get set }
    var coordinator: Coordinator { get set }
}

final class CollectionListViewModel: CollectionListViewModelProtocol {

    var model: CollectionListModel?
    var interactor: CollectionListInteractor

    var coordinator: Coordinator

    init(model: CollectionListModel? = nil,
         interactor: CollectionListInteractor,
         coordinator: Coordinator) {
        self.model = model
        self.interactor = interactor
        self.coordinator = coordinator
    }

}
