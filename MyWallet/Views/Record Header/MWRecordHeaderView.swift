//
//  SWRecordHeaderView.swift
//  MyWallet
//
//  Created by nang saw on 18/02/2021.
//

import UIKit

class MWRecordHeaderView: MWCustomView {

    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var spendingLabel: UILabel?

    override func initUI() {
        self.titleLabel?.font = self.titleLabel?.font.withSize(17)
        self.spendingLabel?.font = self.spendingLabel?.font.withSize(15)
        self.spendingLabel?.textColor = .gray
    }

    func setup(with viewModel: MWRecordHeaderViewModel) {
        self.titleLabel?.text = viewModel.title
        self.spendingLabel?.text = viewModel.spending
    }

}

struct MWRecordHeaderViewModel {
    let title: String?
    let spending: String?
}
