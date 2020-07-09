//
//  DataProvider.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/17.
//  Copyright © 2020 andrew. All rights reserved.
//

import Moya
import Alamofire
import RxSwift
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

    private func request<M: Decodable>(api: AssetApi, decodable: M.Type) -> Single<M> {
        Single<Moya.Response>.create { emitter in
            let task = MoyaProvider.default.request(api) { result in
                switch result {
                case let .success(response):
                    emitter(.success(response))
                case let .failure(moyaError):
                    emitter(.error(moyaError))
                }
            }
            return Disposables.create { task.cancel() }
        }
        .map {
            try $0.data.decode(type: M.self)
        }
    }

    func fetch(owner: String, page: Int) -> Single<[CollectionModel]> {
        request(api: .asset(owner: owner, page: page), decodable: CollectionContainerModel.self)
            .map { $0.assets }
    }

    func getBalance(address: String) -> Single<BalanceModel> {
        request(api: .balance(address: address), decodable: BalanceModel.self)
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
