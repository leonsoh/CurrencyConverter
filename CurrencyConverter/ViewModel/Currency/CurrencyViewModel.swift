//
//  CurrencyViewModel.swift
//  CurrencyConverter
//
//  Created by Leon on 13/7/21.
//

import Foundation

class CurrencyViewModel {
    
    var delegate: CurrencyDataDelegate?
    let apiService = BaseService()
    var currencyData: [Currency] = [] {
        didSet {
            self.delegate?.fetchCurrency(data: currencyData)
        }
    }
    
    func getListOfCurrencies() {
        let endPoint = API.EndPoint.listOfCurrencies
                
        apiService.queryEndPoint(endPoint: endPoint, params: "") { (data) in
            if let data = data as? NSDictionary {
                if let currencies = data.value(forKey: "currencies") as? NSDictionary {
                    for (key, value) in currencies {
                        if let value = value as? String, let key = key as? String {
                            let currency = Currency.init(country: value, countryCode: key, value: nil)
                            self.currencyData.append(currency)
                        }
                    }
                }
            }
        }
    }
    
    func getConvertedAmount(from: String, to: String, amount: Double) {
        let endPoint = API.EndPoint.convert
        let paramsString = "\(ServicesConstants.convertFrom + from)\(ServicesConstants.convertTo + to)\(ServicesConstants.convertAmount)\(amount)"
        
        apiService.queryEndPoint(endPoint: endPoint, params: paramsString) { (data) in
            if let data = data as? NSDictionary {
                if let result = data.value(forKey: "result") as? Double {
                    if let query = data.value(forKey: "query") as? NSDictionary {
                        if let from = query.value(forKey: "from") as? String, let to = query.value(forKey: "to") as? String {
                            self.delegate?.displayConvertedAmount(from: from, to: to, value: result)
                        }
                    }
                }
            }
        }
    }
}
