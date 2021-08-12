//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Leon on 13/7/21.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fromCurrencyTitleLabel: UILabel!
    @IBOutlet weak var toCurrencyTitleLabel: UILabel!
    @IBOutlet weak var fromCurrencyLabel: UILabel!
    @IBOutlet weak var toCurrencyLabel: UILabel!
    @IBOutlet weak var amountToConvertTitleLabel: UILabel!
    @IBOutlet weak var fromCurrencyContainerView: UIView!
    @IBOutlet weak var toCurrencyContainerView: UIView!
    @IBOutlet weak var fromStackView: UIStackView!
    @IBOutlet weak var toStackView: UIStackView!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var resultFromTitleLabel: UILabel!
    @IBOutlet weak var resultToTitleLabel: UILabel!
    @IBOutlet weak var valueFromLabel: UILabel!
    @IBOutlet weak var valueToLabel: UILabel!
    
    
    var listOfCurrencies: [Currency] = []
   
    var currencyStatus: String? {
        didSet {
            updatedStatus = currencyStatus
        }
    }
    
    var viewModel: CurrencyViewModel?
    var updatedStatus: String?
    var updatedListOfCurrencies: [String] = []
    var updatedCurrency: String?
    let segueIdentifier = "displayCurrencyDetails"
    let alertHelper = AlertHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = MainConstants.title
        titleLabel.textAlignment = .center
        
        fromCurrencyTitleLabel.text = MainConstants.fromTitle
        toCurrencyTitleLabel.text = MainConstants.toTitle
        amountToConvertTitleLabel.text = MainConstants.amountTitle
        
        viewModel = CurrencyViewModel()
        viewModel?.delegate = self
        viewModel?.getListOfCurrencies()
        
        amountTextField.delegate = self
        
        let didTapFromCurrencyView = UITapGestureRecognizer(target: self, action:  #selector(self.displayFromCurrencyDetailsView))
        let didTapToCurrencyView = UITapGestureRecognizer(target: self, action:  #selector(self.displayToCurrencyDetailsView))
        fromStackView.addGestureRecognizer(didTapFromCurrencyView)
        toStackView.addGestureRecognizer(didTapToCurrencyView)
        
        amountTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        if listOfCurrencies.isEmpty {
            fromCurrencyLabel.text = MainConstants.defaultCurrencyLabel
            toCurrencyLabel.text = MainConstants.defaultCurrencyLabel
            clearTextField()
        }
        
        self.hideKeyboardWhenTappedAround()
    }
    
    
    //Segues
    @objc func displayFromCurrencyDetailsView() {
        currencyStatus = MainConstants.fromStatus
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    @objc func displayToCurrencyDetailsView() {
        currencyStatus = MainConstants.toStatus
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? MainCurrencyDetailsViewController {
            if let updatedStatus = updatedStatus {
                viewController.status = updatedStatus
            } else { return }
            
            viewController.listOfCurrencies = listOfCurrencies
            viewController.filteredCurrencies = listOfCurrencies
            viewController.delegate = self
            
        }
    }
    
}

extension MainViewController: CurrencyDetailViewDelegate, CurrencyDataDelegate {
    func fetchCurrency(data: [Currency]) {
        listOfCurrencies = data
    }
    
    func setCurrencyTitle(countryTitle: String, countryCode: String, status: String) {
        
        if status == MainConstants.fromStatus {
            fromCurrencyLabel.text = countryTitle
        } else {
            toCurrencyLabel.text = countryTitle
        }
        
        if let fromCurrency = fromCurrencyLabel.text, let toCurrency = toCurrencyLabel.text, let amount = amountTextField.text {
            let fromCode = String(fromCurrency.prefix(3))
            let toCode = String(toCurrency.prefix(3))
            
            if let amount = Double(amount) {
                viewModel?.getConvertedAmount(from: fromCode, to: toCode, amount: amount)
            } else {
                clearTextField() //Clears all result label when there's no converted value
            }
        }
    }
    
    
    func displayConvertedAmount(from: String, to: String, value: Double) {
        DispatchQueue.main.async {
            if let amount = self.amountTextField.text {
                self.resultFromTitleLabel.text = "\(from):"
                self.resultToTitleLabel.text = "\(to):"
                self.valueFromLabel.text = "\(amount)"
                self.valueToLabel.text = "\(value)"
            }
        }
    }
}

extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let components = string.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")
        
        if filtered == string {
            return true
        } else {
            if string == "." {
                let countdots = textField.text!.components(separatedBy:".").count - 1
                if countdots == 0 {
                    return true
                } else {
                    if countdots > 0 && string == "." {
                        return false
                    } else {
                        return true
                    }
                }
            } else {
                return false
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let fromLabel = fromCurrencyLabel.text, let toLabel = toCurrencyLabel.text, let text = textField.text {
            let currencyCodeFrom = String(fromLabel.prefix(3))
            let currencyCodeTo = String(toLabel.prefix(3))
            if let amount = Double(text) {
                viewModel?.getConvertedAmount(from: currencyCodeFrom, to: currencyCodeTo, amount: amount)
            } else {
                clearTextField() //Clears all result label when there's no converted value
            }
        }
    }
    
    func clearTextField() {
        resultFromTitleLabel.text = ""
        resultToTitleLabel.text = ""
        valueToLabel.text = ""
        valueFromLabel.text = ""
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 50, width:self.view.frame.size.width, height:self.view.frame.size.height)
            
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 50, width:self.view.frame.size.width, height:self.view.frame.size.height)
        })
        
        if let textCount = textField.text?.count {
            if textCount > 0 {
                if fromCurrencyLabel.text == MainConstants.defaultCurrencyLabel || toCurrencyLabel.text == MainConstants.defaultCurrencyLabel {
                    alertHelper.emptyFieldError(controller: self)
                }
            }
        }
    }
}
