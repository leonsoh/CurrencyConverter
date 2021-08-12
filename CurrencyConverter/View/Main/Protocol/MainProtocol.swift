//
//  MainProtocol.swift
//  CurrencyConverter
//
//  Created by Leon on 14/7/21.
//

import Foundation

protocol CurrencyDetailViewDelegate {
    func setCurrencyTitle(countryTitle: String, countryCode: String, status: String)
}

protocol CurrencyDataDelegate {
    func displayConvertedAmount(from: String, to: String, value: Double)
    func fetchCurrency(data: [Currency])
}
