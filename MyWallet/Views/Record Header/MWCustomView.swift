//
//  MWCustomView.swift
//  MyWallet
//
//  Created by nang saw on 18/02/2021.
//

import UIKit

@IBDesignable class MWCustomView: UIView {

    @IBOutlet weak var view: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.nibSetup()
        self.initUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.nibSetup()
        self.initUI()
    }

    private func nibSetup() {
        self.backgroundColor = .clear

        self.view = loadViewFromNib()
        self.view.frame = bounds
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.translatesAutoresizingMaskIntoConstraints = true

        self.addSubview(view)
    }

    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView

        return nibView
    }

    func initUI() {

    }

}
