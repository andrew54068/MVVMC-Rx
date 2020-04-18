//
//  DataProvider.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/17.
//  Copyright © 2020 andrew. All rights reserved.
//

import Foundation

enum CollectionModelResult {
    case model([CollectionModel])
    case error(Error)
}

class DataProvider {

    static let shared: DataProvider = DataProvider()

    private init() { }

    func fetch(owner: String, completion: @escaping (CollectionModelResult) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: {
            completion(.model([CollectionModel()]))
        })
    }
}
