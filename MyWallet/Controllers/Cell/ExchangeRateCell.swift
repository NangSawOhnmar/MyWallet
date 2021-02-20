//
//  ExchangeRateCell.swift
//  MyWallet
//
//  Created by nang saw on 20/02/2021.
//

import UIKit

class ExchangeRateCell: UITableViewCell {

    static let IDENTIFIER: String = "ExchangeRateCell"
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
