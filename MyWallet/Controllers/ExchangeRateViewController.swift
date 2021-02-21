//
//  ExchangeRateViewController.swift
//  MyWallet
//
//  Created by nang saw on 20/02/2021.
//

import UIKit

class ExchangeRateViewController: UIViewController {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedCurrencyLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let currencyCurrencySymbol = NSLocale.defaultCurrency
    var exchangeRates = [Rate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        iconLabel.text = flag(country: NSLocale.defaultCurrencyCountryCode)
        selectedCurrencyLabel.text = currencyCurrencySymbol
        
        getExchangeRate()

    }
    
    func flag(country:String) -> String {
        let base = 127397
        var usv = String.UnicodeScalarView()
        for i in country.utf16 {
            usv.append(UnicodeScalar(base + Int(i))!)
        }
        return String(usv)
    }
    
    func getExchangeRate() {
        activityIndicatorView.startAnimating()
        ExchangeRateClient.requestExchangeRates(country: NSLocale.defaultCurrencyCode, completionHandler: handleExchangeResponse(exchangeRates:error:))
    }
    
    func handleExchangeResponse(exchangeRates: [Rate],error: Error?) {
        if error != nil {
            self.errorAlertView(title: "", message: error?.localizedDescription ?? "")
            self.activityIndicatorView.stopAnimating()
        }
        self.exchangeRates = exchangeRates
        DispatchQueue.main.async {
            guard let date = self.exchangeRates[0].lastUpdateDate else {
                return
            }
            self.dateLabel.text = "Last Update: \(date)"
            self.tableView.reloadData()
            self.activityIndicatorView.stopAnimating()
        }
    }

}

extension ExchangeRateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchangeRates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateCell.IDENTIFIER, for: indexPath) as! ExchangeRateCell

        let currencyItem = exchangeRates[indexPath.row]

        cell.symbolLabel.text = currencyItem.currencyCode
        cell.nameLabel.text = currencyItem.countryName
        cell.iconLabel.text = flag(country: currencyItem.countryCode)
        
        if currencyItem.amount != 0.0 {
            cell.amountLabel.text = "\(currencyItem.amount)"
        }

        return cell
    }
    
    
}
