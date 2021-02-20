//
//  ExchangeResponse.swift
//  MyWallet
//
//  Created by nang saw on 20/02/2021.
//

import Foundation

struct ExchangeResponse: Codable {
    let rates: [String: Double]
    let base: String
    let date: String
}

struct Rate {
    let currencyCode: String
    let currencyName: String
    let countryCode: String
    let countryName: String
    let amount: Double
    let lastUpdateDate: String
}
