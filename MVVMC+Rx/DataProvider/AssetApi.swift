//
//  AssetApi.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/18.
//  Copyright © 2020 andrew. All rights reserved.
//

import Moya

enum AssetApi: TargetType {
    case asset(owner: String, page: Int)
    case balance(address: String)

    var baseURL: URL {
        switch self {
        case .asset:
            return URL(string: "https://api.opensea.io/")!
        case .balance:
            return URL(string: "https://api.etherscan.io/")!
        }
    }

    var path: String {
        switch self {
        case .asset: return "api/v1/assets"
        case .balance: return "api/"
        }
    }

    var method: Method {
        return .get
    }

    var sampleData: Data { return Data() }

    var task: Task {
        switch self {
        case let .asset(owner, page):
            return .requestParameters(parameters: ["format":"json",
                                                   "owner": owner,
                                                   "offset": page,
                                                   "limit": 20],
                                      encoding: URLEncoding.default)
        case let .balance(address):
            return .requestParameters(parameters: ["module": "account",
                                                   "action": "balance",
                                                   "address": address],
                                      encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? { nil }

}
