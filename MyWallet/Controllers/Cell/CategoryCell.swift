//
//  CategoryCell.swift
//  MyWallet
//
//  Created by nang saw on 19/02/2021.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let IDENTIFIER: String = "CategoryCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(model: CategoryTableViewCellModel) {
        self.titleLabel?.text = model.title
        self.iconView?.image = model.icon
    }

}

struct CategoryTableViewCellModel {
    let title: String?
    let icon: UIImage?
}
