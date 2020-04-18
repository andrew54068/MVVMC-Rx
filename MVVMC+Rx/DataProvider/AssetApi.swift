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

    var baseURL: URL {
        return URL(string: "https://api.opensea.io/")!
    }

    var path: String {
        switch self {
        case .asset: return "api/v1/assets"
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
        }
    }

    var headers: [String: String]? { nil }

}
