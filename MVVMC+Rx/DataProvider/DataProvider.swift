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

enum BalanceModelResult {
    case model(String)
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

    func getBalance(address: String, completion: @escaping (BalanceModelResult) -> Void) {
        let target: AssetApi = .balance(address: address)
        MoyaProvider.default.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let model: BalanceModel = try response.data.decode(type: BalanceModel.self)
                    completion(.model(model.balanceValue))
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
        return MoyaProvider<Target>(plugins: [NetworkLogger()])
    }

}

class NetworkLogger: PluginType {

    func willSend(_ request: RequestType, target: TargetType) {
        print(request.request?.httpBody?.jsonPrettyPrinted() ?? "httpBody is nil")
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            print(response.data.jsonPrettyPrinted())
        case let .failure(error):
            print(error)
        }
    }

}
