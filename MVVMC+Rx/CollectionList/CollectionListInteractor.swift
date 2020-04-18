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
    var modelObservable: Observable<[CollectionModel]> { get }
    func fetch() -> Observable<[CollectionModel]>
}

final class CollectionListInteractor: CollectionListInteractorProtocol {
    
    var modelObservable: Observable<[CollectionModel]> { return modelSubject.asObservable() }
    private let modelSubject: PublishSubject<[CollectionModel]> = PublishSubject()

    private let owner: String
    private let dataProvider: DataProvider

    init(owner: String, dataProvider: DataProvider) {
        self.owner = owner
        self.dataProvider = dataProvider
    }

    func fetch() -> Observable<[CollectionModel]> {
        return Observable<[CollectionModel]>.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            DataProvider.shared.fetch(owner: self.owner) { result in
                switch result {
                case let .model(collectionModels):
                    observer.onNext(collectionModels)
                case let .error(error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

}
