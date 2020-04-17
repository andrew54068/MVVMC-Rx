//
//  CollectionListInteractor.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/17.
//  Copyright © 2020 andrew. All rights reserved.
//

import RxRelay
import RxSwift

protocol CollectionListInteractorProtocol {
    var model: [CollectionModel] { get set }
    func fetch()
}

final class CollectionListInteractor: CollectionListInteractorProtocol {

    var modelObservable: Observable<[CollectionModel]> { return modelRelay.asObservable() }
    private let modelRelay: BehaviorRelay<[CollectionModel]> = BehaviorRelay(value: [])
    var model: [CollectionModel] = []

    private let owner: String
    private let dataProvider: DataProvider

    init(owner: String, dataProvider: DataProvider) {
        self.owner = owner
        self.dataProvider = dataProvider
    }

    func fetch() {
        DataProvider.shared.fetch(owner: owner) { models in
            modelRelay.accept(models)
        }
    }

}
