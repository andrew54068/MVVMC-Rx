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
    func fetchAssets(page: Int) -> Observable<[CollectionModel]>
    func getBalance() -> Observable<String>
}

final class CollectionListInteractor: CollectionListInteractorProtocol {

    private let owner: String
    private let dataProvider: DataProvider

    init(owner: String, dataProvider: DataProvider) {
        self.owner = owner
        self.dataProvider = dataProvider
    }

    func fetchAssets(page: Int) -> Observable<[CollectionModel]> {
        return Observable<[CollectionModel]>.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            DataProvider.shared.fetch(owner: self.owner, page: page) { result in
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

    func getBalance() -> Observable<String> {
        return Observable<String>.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            DataProvider.shared.getBalance(address: self.owner) { result in
                switch result {
                case let .model(balance):
                    observer.onNext(balance)
                case let .error(error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

}
