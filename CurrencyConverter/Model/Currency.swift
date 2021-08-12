//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Leon on 13/7/21.
//

import Foundation

struct Currency {
    let country: String
    let countryCode: String
    let value: Double?
    
    init(country: String, countryCode: String, value: Double?) {
        self.country = country
        self.countryCode = countryCode
        self.value = value
    }
}


