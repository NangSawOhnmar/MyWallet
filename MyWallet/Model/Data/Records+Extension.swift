//
//  Records+Extension.swift
//  MyWallet
//
//  Created by nang saw on 18/02/2021.
//

import Foundation

enum DirectionType {
    case cost
    case income
}

extension Records {
    var directionType: DirectionType {
        if self.direction == -1 {
            return .cost
        } else {
            return .income
        }
    }
}

extension Sequence where Element: Records {

    func sum() -> MWRecordRepresentation {
        let costs = self.sumAmount(type: .cost)
        let incomes = self.sumAmount(type: .income)

        let total = incomes - costs

        return MWRecordRepresentation(
            type: .total,
            value: total,
            recordType: .all
        )
    }

    func sumAmount(type: DirectionType) -> Double {
        return self.filter({ $0.directionType == type })
        .map({ record in record.amount})
        .reduce(0, +)
    }
}
