//
//  AddFile.swift
//  MyWallet
//
//  Created by nang saw on 18/02/2021.
//

import Foundation

class AddRecordModel {
    var amount: Double = 0
    var datetime = Date()
    var direction = 0
    var note: String?
    var reported: Bool?
    var uid: String?
    var expenseIndex = 0
    var incomeIndex = 0
    var accountIndex = 0
}
