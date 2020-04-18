//
//  DataProvider.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/17.
//  Copyright © 2020 andrew. All rights reserved.
//

import Moya
import Alamofire

enum CollectionModelResult {
    case model([CollectionModel])
    case error(Error)
}

class DataProvider {

    typealias ResponseSuccess<Model: Decodable> = (Model) -> Void
    typealias ResponseError = (MoyaError) -> Void

    static let shared: DataProvider = DataProvider()

    private init() { }

    func fetch(owner: String, page: Int, completion: @escaping (CollectionModelResult) -> Void) {
        let target: AssetApi = .asset(owner: owner, page: page)
        MoyaProvider.default.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let model: CollectionContainerModel = try response.data.decode(type: CollectionContainerModel.self)
                    completion(.model(model.assets))
                } catch {
                    completion(.error(error))
                }
            case let .failure(moyaError):
                completion(.error(moyaError))
            }
        }
    }

}

extension MoyaProvider {

    final class var `default`: MoyaProvider {
        return MoyaProvider<Target>()
    }

}

extension Data {

    func decode<Model: Decodable>(type: Model.Type, decoder: JSONDecoder = JSONDecoder()) throws -> Model {
        let decoder: JSONDecoder = .init()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(type, from: self)
    }

}
