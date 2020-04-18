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
    var currentPage: Int = 0

    private let bag = DisposeBag()

    init(interactor: CollectionListInteractor,
         coordinator: Coordinator) {
        self.interactor = interactor
        self.coordinator = coordinator
    }

    func fetchData() -> Observable<[CollectionModel]> {
        let observer: Observable<[CollectionModel]> = interactor.fetch(page: currentPage)
        observer
            .observeOn(MainScheduler.instance)
            .subscribe({ [weak self] event in
                guard let self = self else { return }
                switch event {
                case .next:
                    self.currentPage += 1
                default:
                    ()
                }
            })
            .disposed(by: bag)
        return observer
    }

}
