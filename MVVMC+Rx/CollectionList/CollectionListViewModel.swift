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
    var models: BehaviorSubject<[CollectionModel]> = BehaviorSubject(value: [])
    let error: PublishSubject<Error> = PublishSubject()
    let loading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let loadingMore: BehaviorSubject<Bool> = BehaviorSubject(value: false)

    var interactor: CollectionListInteractorProtocol
    var coordinator: CollectionListCoordinatorProtocol

    private var currentPage: Int = 0

    private let bag = DisposeBag()

    init(interactor: CollectionListInteractorProtocol,
         coordinator: CollectionListCoordinatorProtocol) {
        self.interactor = interactor
        self.coordinator = coordinator
    }

    func fetchFirst() {
        loading.onNext(true)
        fetchAssets(page: 0)
            .subscribe({ [weak self] event in
                self?.loading.onNext(false)
                guard let self = self else { return }
                switch event {
                case let .next(models):
                    self.models.onNext(models)
                case let .error(error):
                    self.error.onNext(error)
                default:
                    ()
                }
            })
            .disposed(by: bag)

        interactor.getBalance()
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

    func loadMore() {
        loadingMore.onNext(true)
        fetchAssets(page: currentPage + 1)
            .subscribe({ [weak self] event in
                self?.loadingMore.onNext(false)
                guard let self = self else { return }
                switch event {
                case let .next(models):
                    self.currentPage += 1
                    self.models.append(element: models)
                case let .error(error):
                    self.error.onNext(error)
                default:
                    ()
                }
            })
            .disposed(by: bag)
    }

    private func fetchAssets(page: Int = 0) -> Observable<[CollectionModel]> {
        return interactor.fetchAssets(page: page)
        .observeOn(MainScheduler.instance)
    }

    func present(with model: CollectionModel) {
        coordinator.navigate(with: model)
    }

}

extension BehaviorSubject where Element: RangeReplaceableCollection {

    func append(element: Element) {
        do {
            try onNext(value() + element)
        } catch {
            onError(error)
        }
    }

    func add(element: Element) {

    }

}
