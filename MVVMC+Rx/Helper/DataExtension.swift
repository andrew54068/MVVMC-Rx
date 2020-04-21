//
//  DataExtension.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/18.
//  Copyright © 2020 andrew. All rights reserved.
//

import Foundation

extension Data {

    func decode<Model: Decodable>(type: Model.Type, decoder: JSONDecoder = JSONDecoder()) throws -> Model {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(type, from: self)
    }

}

extension Data {

    func jsonPrettyPrinted() -> String {
        if let json: Any = try? JSONSerialization.jsonObject(with: self,
                                                             options: []),
            let prettyPrint: Data = try? JSONSerialization.data(withJSONObject: json,
                                                           options: .prettyPrinted),
            let prettyPrintedString: String = String(data: prettyPrint, encoding: .utf8) {
            return prettyPrintedString
        } else {
            if isEmpty {
                return "data is empty."
            } else {
                return "data is not json string."
            }
        }
    }

}

extension String {

    func jsonPrettyPrinted() -> String {
        return self.data(using: .utf8)?.jsonPrettyPrinted() ?? "not be able to convert to data."
    }

}
