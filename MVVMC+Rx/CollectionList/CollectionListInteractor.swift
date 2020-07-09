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
    func fetchAssets(page: Int) -> Single<[CollectionModel]>
    func getBalance() -> Single<String>
}

final class CollectionListInteractor: CollectionListInteractorProtocol {

    private let owner: String
    private let dataProvider: DataProvider

    init(owner: String, dataProvider: DataProvider) {
        self.owner = owner
        self.dataProvider = dataProvider
    }

    func fetchAssets(page: Int) -> Single<[CollectionModel]> {
        DataProvider.shared.fetch(owner: self.owner, page: page) 
    }

    func getBalance() -> Single<String> {
        DataProvider.shared.getBalance(address: self.owner).map { $0.balanceValue }
    }

}
