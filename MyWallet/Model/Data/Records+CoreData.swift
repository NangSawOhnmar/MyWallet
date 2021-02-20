//
//  Records+CoreData.swift
//  MyWallet
//
//  Created by nang saw on 18/02/2021.
//

import Foundation

extension Records {
    public override func willSave() {
        super.willSave()
        
        if self.year != Int64((datetime?.year()) ?? 0) {
            self.year = Int64(datetime?.year() ?? 0)
        }

        if self.month != Int64(datetime?.month() ?? 0) {
            self.month = Int16(datetime?.month() ?? 0)
        }
    }

}
