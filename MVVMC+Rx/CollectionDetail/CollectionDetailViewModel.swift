//
//  CollectionDetailViewModel.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/19.
//  Copyright © 2020 andrew. All rights reserved.
//

import Foundation
import RxSwift

final class CollectionDetailViewModel {

    var interactor: CollectionDetailInteractor
    var coordinator: CollectionDetailCoordinator

    var modelObservable: Observable<CollectionModel> { return modelSubject.asObserver() }
    var modelSubject: BehaviorSubject<CollectionModel>

    init(interactor: CollectionDetailInteractor,
         coordinator: CollectionDetailCoordinator,
         model: CollectionModel) {
        self.interactor = interactor
        self.coordinator = coordinator
        modelSubject = BehaviorSubject(value: model)
    }
    
}
