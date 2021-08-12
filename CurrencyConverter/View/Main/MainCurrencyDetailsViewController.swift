//
//  MainCurrencyDetailsViewController.swift
//  CurrencyConverter
//
//  Created by Leon on 14/7/21.
//

import UIKit

class MainCurrencyDetailsViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let cellReuseIdentifier = "currencyCell"
    let currencyDetailsNib = "CurrencyDetailsTableViewCell"
    var listOfCurrencies: [Currency] = []
    var filteredCurrencies: [Currency] = []
    
    var delegate: CurrencyDetailViewDelegate?
    var status: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: currencyDetailsNib, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        searchBar.delegate = self
        
        headerTitleLabel.text = status == MainConstants.fromStatus ? MainConstants.currencyDetailsTitleFrom : MainConstants.currencyDetailsTitleTo
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

}

extension MainCurrencyDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CurrencyDetailsTableViewCell
        let currency = filteredCurrencies[indexPath.row]
        
        cell.titleLabel.text = "\(currency.countryCode) - \(currency.country)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = filteredCurrencies[indexPath.row]
        let countryTitle = "\(currency.countryCode) - \(currency.country)"
        
        if let status = status {
            delegate?.setCurrencyTitle(countryTitle: countryTitle, countryCode: currency.countryCode , status: status)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MainCurrencyDetailsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredCurrencies = searchText.isEmpty ? listOfCurrencies : listOfCurrencies.filter { (item: Currency) -> Bool in
            let currencies = item.countryCode + item.country
            return currencies.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            
        }
        
        tableView.reloadData()
    }
}

