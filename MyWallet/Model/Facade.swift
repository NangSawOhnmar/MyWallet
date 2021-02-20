//
//  Facade.swift
//  MyWallet
//
//  Created by nang saw on 18/02/2021.
//

import Foundation

class Facade {
    static let share = Facade()
    let model = PersistentModel()
}
