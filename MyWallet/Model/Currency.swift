//
//  Currency.swift
//  MyWallet
//
//  Created by nang saw on 18/02/2021.
//

import Foundation

class Currency {
    
    var countryName: String?
    var countryCode: String?
    var currencyCode: String?
    var currencyName: String?
    var currencySymbol: String?
    
    func loadEveryCountryWithCurrency() -> [Currency] {
        var result = [Currency]()
        let currencies = Locale.commonISOCurrencyCodes
        
        for currencyCode in currencies {
            
            let currency = Currency()
            currency.currencyCode = currencyCode
            
            let currencyLocale = Locale(identifier: currencyCode)
            
            currency.currencyName = (currencyLocale as NSLocale).displayName(
                forKey: NSLocale.Key.currencyCode,
                value: currencyCode)
            let index = currencyCode.index(currencyCode.startIndex, offsetBy: 2)
            currency.countryCode = String(currencyCode[..<index])
            currency.currencySymbol = (currencyLocale as NSLocale).displayName(
                forKey: NSLocale.Key.currencySymbol,
                value: currencyCode)
            
            let countryLocale  = NSLocale.current
            currency.countryName = (countryLocale as NSLocale).displayName(
                forKey: NSLocale.Key.countryCode,
                value: currency.countryCode!)
            
            if currency.countryName != nil {
                result.append(currency)
            }
            
        }
        return result
    }
}
