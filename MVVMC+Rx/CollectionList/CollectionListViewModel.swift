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
    var interactor: CollectionListInteractor { get set }
    var coordinator: Coordinator { get set }
}

final class CollectionListViewModel: CollectionListViewModelProtocol {

    var interactor: CollectionListInteractor
    var coordinator: Coordinator

    private let bag = DisposeBag()

    init(interactor: CollectionListInteractor,
         coordinator: Coordinator) {
        self.interactor = interactor
        self.coordinator = coordinator
    }

    func fetchData() -> Observable<[CollectionModel]> {
        return interactor.fetch()
    }

}
