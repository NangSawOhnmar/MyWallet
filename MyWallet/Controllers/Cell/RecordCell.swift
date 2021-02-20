//
//  RecordCell.swift
//  MyWallet
//
//  Created by nang saw on 18/02/2021.
//

import UIKit

class RecordCell: UITableViewCell {

    static let IDENTIFIER: String = "RecordCell"
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if UIScreen.main.nativeBounds.height == 1136 {
            amountLabel.font = amountLabel.font.withSize(17)
            titleLabel.font = titleLabel.font.withSize(14)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
