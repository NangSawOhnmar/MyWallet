//
//  CostCell.swift
//  MyWallet
//
//  Created by nang saw on 18/02/2021.
//

import UIKit

class CostCell: UITableViewCell {

    @IBOutlet var iconView: UIImageView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var budgetAmount: UITextField!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var budgetPercentage: UIProgressView!
    weak var budgetDelegate: BudgetFieldDelegate?
    static let IDENTIFIER: String = "CostCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if amountLabel != nil {
            amountLabel.text = NSLocale.defaultCurrency
        }
        budgetAmount.delegate = self

        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.myAppLightOrange
        self.selectedBackgroundView = bgColorView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func makeFirstResponder() {
        budgetAmount.becomeFirstResponder()
    }
}

extension CostCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setSelected(true, animated: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        setSelected(false, animated: true)
        self.budgetDelegate?.didEndEditing(cell: self)
    }
}

protocol BudgetFieldDelegate: AnyObject {
    func didEndEditing(cell: CostCell)
}
