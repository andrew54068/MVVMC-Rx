//
//  CollectionListInteractor.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/17.
//  Copyright © 2020 andrew. All rights reserved.
//

protocol CollectionListInteractorProtocol {
    var model: [CollectionListModel] { get set }
    func fetch()
}

final class CollectionListInteractor: CollectionListInteractorProtocol {

    var model: [CollectionListModel] = []

    func fetch() {
    }


}
