//
//  BalanceModel.swift
//  MVVMC+Rx
//
//  Created by kidnapper on 2020/4/19.
//  Copyright © 2020 andrew. All rights reserved.
//

import Foundation

struct BalanceModel: Decodable {
    private let result: String

    var balanceValue: String {
        let decimal: Decimal = Decimal(string: result) ?? .nan
        let devider: Decimal = pow(Decimal(integerLiteral: 10), 18)
        let result: Decimal = decimal / devider
        let formatter: NumberFormatter = NumberFormatter()
        formatter.maximumFractionDigits = 8
        formatter.minimumIntegerDigits = 1
        return "ether balance: " + (formatter.string(from: (result as NSDecimalNumber)) ?? "0")
    }
}
