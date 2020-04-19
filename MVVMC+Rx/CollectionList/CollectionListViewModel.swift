//
//  CollectionListViewModel.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/17.
//  Copyright © 2020 andrew. All rights reserved.
//

import RxRelay
import RxSwift

final class CollectionListViewModel {

    let balance: PublishSubject<String> = PublishSubject()
    let models: PublishSubject<[CollectionModel]> = PublishSubject()
    let loading: PublishSubject<Bool> = PublishSubject()
    let error: PublishSubject<Error> = PublishSubject()

    var interactor: CollectionListInteractorProtocol
    var coordinator: CollectionListCoordinatorProtocol
    var currentPage: Int = 0

    private let bag = DisposeBag()

    init(interactor: CollectionListInteractorProtocol,
         coordinator: CollectionListCoordinatorProtocol) {
        self.interactor = interactor
        self.coordinator = coordinator
    }

    func fetchData() {
        loading.onNext(true)
        let observer: Observable<[CollectionModel]> = interactor.fetchAssets(page: currentPage)
        observer
            .observeOn(MainScheduler.instance)
            .subscribe({ [weak self] event in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.loading.onNext(false)
                }
                guard let self = self else { return }
                switch event {
                case let .next(models):
                    self.currentPage += 1
                    self.models.onNext(models)
                case let .error(error):
                    self.error.onNext(error)
                default:
                    ()
                }
            })
            .disposed(by: bag)

        let balanceObserver: Observable<String> = interactor.getBalance()
        balanceObserver
            .observeOn(MainScheduler.instance)
            .subscribe({ [weak self] event in
                guard let self = self else { return }
                switch event {
                case let .next(balance):
                    self.balance.onNext(balance)
                case let .error(error):
                    self.error.onNext(error)
                default:
                    ()
                }
            })
            .disposed(by: bag)

    }

    func present(with model: CollectionModel) {
        coordinator.navigate(with: model)
    }

}
