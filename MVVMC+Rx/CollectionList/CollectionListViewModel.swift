//
//  CollectionListViewModel.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/17.
//  Copyright © 2020 andrew. All rights reserved.
//

import RxRelay
import RxSwift

protocol CollectionListViewModelProtocol {
    var collectionModelObservable: Observable<[CollectionModel]> { get }
    var interactor: CollectionListInteractor { get set }
    var coordinator: Coordinator { get set }
}

final class CollectionListViewModel: CollectionListViewModelProtocol {

    var collectionModelObservable: Observable<[CollectionModel]> { return collectionModelRelay.asObservable() }
    private let collectionModelRelay: BehaviorRelay<[CollectionModel]>

    var interactor: CollectionListInteractor
    var coordinator: Coordinator

    init(model: CollectionModel? = nil,
         interactor: CollectionListInteractor,
         coordinator: Coordinator) {
        if let model: CollectionModel = model {
            collectionModelRelay = BehaviorRelay(value: [model])
        } else {
            collectionModelRelay = BehaviorRelay(value: [])
        }
        self.interactor = interactor
        self.coordinator = coordinator
    }

    func fetchData() {

    }

}
