//
//  DataProvider.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/17.
//  Copyright © 2020 andrew. All rights reserved.
//

import Foundation

class DataProvider {

    static let shared: DataProvider = DataProvider()

    private init() { }

    func fetch(owner: String, completion: ([CollectionModel]) -> Void) {
        
    }
}
