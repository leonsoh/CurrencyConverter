//
//  AlertHelper.swift
//  CurrencyConverter
//
//  Created by Leon on 14/7/21.
//

import Foundation
import UIKit

class AlertHelper {
    
    func defaultErrorAlert(title: String?, message: String, controller: UIViewController) {
        var defaultTitle = "Error"
        
        if let title = title {
            defaultTitle = title
        }
        
        let alert = UIAlertController(title: defaultTitle, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    func emptyFieldError(controller: UIViewController) {
        let defaultTitle = "Error"
        let message = AppConstants.emptyFieldErrorMessage
        
        let alert = UIAlertController(title: defaultTitle, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            controller.present(alert, animated: true, completion: nil)
        }
    }
}
