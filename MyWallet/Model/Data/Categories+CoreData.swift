//
//  Categories+CoreData.swift
//  MyWallet
//
//  Created by nang saw on 18/02/2021.
//

import Foundation
import CoreData

extension Categories {

    public override func willSave() {
        super.willSave()

        if self.sortId == 0 {
            setPrimitiveValue(getAutoIncremenet(), forKey: "sortId")
        }
    }

    func getAutoIncremenet() -> Int64 {
        let url = self.objectID.uriRepresentation()
        let urlString = url.absoluteString
        if let partialNumber = urlString.components(separatedBy: "/").last {
            let numberPart = partialNumber.replacingOccurrences(of: "p", with: "")
            if let number = Int64(numberPart) {
                return number
            }
        }
        return 0
    }

}

