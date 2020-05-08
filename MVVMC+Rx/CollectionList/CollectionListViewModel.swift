//
//  CollectionListViewModel.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/17.
//  Copyright © 2020 andrew. All rights reserved.
//

import RxRelay
import RxSwift
import RxCocoa

final class CollectionListViewModel {
    private let coordinator: CollectionListCoordinatorProtocol
    private let modelsRelay = PublishRelay<[[CollectionModel]]>()
    private let balanceRelay = PublishRelay<String>()
    private let fetchModelsTrigger = PublishRelay<Void>()
    private let fetchBalanceTrigger = PublishRelay<Void>()
    private let bag = DisposeBag()

    let models: Driver<[CollectionModel]>
    let balance: Driver<String>
    let error: Driver<Error>
    let isLoading: Driver<Bool>


    init(interactor: CollectionListInteractorProtocol,
         coordinator: CollectionListCoordinatorProtocol) {
        self.coordinator = coordinator

        models = modelsRelay.map { $0.flatMap { $0 } }
            .asDriver(onErrorJustReturn: [])
        balance = balanceRelay
            .asDriver(onErrorJustReturn: "")

        let modelStream = fetchModelsTrigger
            .withLatestFrom(modelsRelay)
            .flatMapFirst { models in
                interactor.fetchAssets(page: models.count).map { models + [$0] }
            }

        isLoading = Observable.merge(
            fetchModelsTrigger.map { true },
            modelStream.map { _ in false }
                .catchError { _ in .just(false) }
        )
            .asDriver(onErrorJustReturn: false)

        modelStream
            .catchError { _ in .empty() }
            .bind(to: modelsRelay)
            .disposed(by: bag)

        let balanceStream = fetchBalanceTrigger
            .flatMapFirst { interactor.getBalance() }
        balanceStream
            .catchError { _ in .empty() }
            .bind(to: balanceRelay)
            .disposed(by: bag)


        error = Observable.merge(
            modelStream.compactMap { _ in nil }
                .catchError { .just($0) },
            balanceStream.compactMap { _ in nil }
                .catchError { .just($0) }
        )
            .asDriver(onErrorDriveWith: .empty())

    }

    func fetchFirst() {
        modelsRelay.accept([])
        fetchModelsTrigger.accept(())
        fetchBalanceTrigger.accept(())
    }

    func loadMore() {
        fetchModelsTrigger.accept(())
    }

    func present(with model: CollectionModel) {
        coordinator.navigate(with: model)
    }

}
