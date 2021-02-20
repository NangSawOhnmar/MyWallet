//
//  ViewController.swift
//  MyWallet
//
//  Created by nang saw on 18/02/2021.
//

import UIKit

class ChooseCurrencyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var currencyList = [Currency]()
    let currencyCurrencySymbol = NSLocale.defaultCurrency
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let currecy = Currency()
        currencyList = currecy.loadEveryCountryWithCurrency()
    }
}

extension ChooseCurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath)
        cell.backgroundColor = UIColor.white

        let currencyItem = currencyList[indexPath.row]

        cell.detailTextLabel?.text = currencyItem.currencySymbol!

        if currencyCurrencySymbol == currencyItem.currencySymbol {
            cell.textLabel?.text = currencyItem.currencyName! + " ✓"
            cell.backgroundColor = UIColor.myAppLightOrange
        } else {
            cell.textLabel?.text = currencyItem.currencyName
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currencyItem = currencyList[indexPath.row]

        if let symbol = currencyItem.currencySymbol {
            NSLocale.setupDefaultCurrency(symbol: symbol)
        }
        if let countrycode = currencyItem.countryCode {
            NSLocale.setupDefaultCurrencyCode(code: countrycode)
        }
        
        if let currencyCode = currencyItem.currencyCode {
            NSLocale.setupDefaultCurrencyCode(code: currencyCode)
        }

        navigationController?.popViewController(animated: true)
    }
    
}

