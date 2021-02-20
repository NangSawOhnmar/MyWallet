//
//  NSLocale+Extension.swift
//  MyWallet
//
//  Created by nang saw on 18/02/2021.
//

import Foundation

extension NSLocale {
    static var defaultCurrency: String {
        return UserDefaults.standard.string(forKey: UserDefaults.currencySymbolKey) ?? ""
    }

    static func setupDefaultCurrency(symbol: String) {
        UserDefaults.standard.set(symbol, forKey: UserDefaults.currencySymbolKey)
    }
    
    static var defaultCurrencyCountryCode: String {
        return UserDefaults.standard.string(forKey: UserDefaults.currencyCountryCodeKey) ?? ""
    }
    
    static func setupDefaultCurrencyCountryCode(code: String) {
        UserDefaults.standard.set(code, forKey: UserDefaults.currencyCountryCodeKey)
    }
    
    static var defaultCurrencyCode: String {
        return UserDefaults.standard.string(forKey: UserDefaults.currencyCodeKey) ?? ""
    }

    static func setupDefaultCurrencyCode(code: String) {
        UserDefaults.standard.set(code, forKey: UserDefaults.currencyCodeKey)
    }
}

extension UserDefaults {
    static let currencySymbolKey = "currencySymbol"
    static let currencyCountryCodeKey = "currencyCountryCode"
    static let currencyCodeKey = "currencyCode"
    static let snapshotKey = "FASTLANE_SNAPSHOT"
}
