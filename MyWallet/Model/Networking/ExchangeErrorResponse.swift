//
//  ExchangeErrorResponse.swift
//  MyWallet
//
//  Created by nang saw on 20/02/2021.
//

import Foundation

struct ExchangeErrorResponse: Codable {
    let error: String
}

extension ExchangeErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
