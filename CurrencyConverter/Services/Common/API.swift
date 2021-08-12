//
//  API.swift
//  CurrencyConverter
//
//  Created by Leon on 13/7/21.
//

import Foundation

struct API {
    static let accessKey: String = "" // API Key
    static let baseUrl: String = "https://api.currencylayer.com/"
    
    struct EndPoint {
        static let live = "live"
        static let listOfCurrencies = "list"
        static let convert = "convert"
    }
    
    struct method {
        static let post = "POST"
        static let get = "GET"
        static let put = "PUT"
        static let patch = "PATCH"
        static let delete = "DELETE"
    }
}
