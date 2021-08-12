//
//  BaseErrorHandler.swift
//  CurrencyConverter
//
//  Created by Leon on 14/7/21.
//

import Foundation
import UIKit

class BaseErrorHandler {
    
    let alertHelper = AlertHelper()
    
    func displayError() {
        DispatchQueue.main.async {
            self.alertHelper.defaultErrorAlert(title: nil, message: ErrorMessage.defaultError, controller: UIApplication.topMostViewController!)
        }
        print("Service error occured!")
        return
    }
    
    func serviceError() {
        NSLog("Data is null!")
    }
}
