//
//  SWMonth.swift
//  MyWallet
//
//  Created by nang saw on 18/02/2021.
//

import Foundation

struct MWMonth {
    let year: Int?
    let shortYear: Int
    let month: Int?
    let title: String
    let shortTitle: String
    let currentYear: Bool

    var titleWithYear: String {
        return "\(title) \(year)"
    }

    var shortTitleWithYear: String {
        return "\(shortTitle) \(shortYear)"
    }

    var titleWithCurrentYear: String {
        return currentYear ? title : titleWithYear
    }

    var shortTitleWithCurrentYear: String {
        return currentYear ? shortTitle : shortTitleWithYear
    }
}
