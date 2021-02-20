//
//  UIViewController+Extension.swift
//  MyWallet
//
//  Created by nang saw on 19/02/2021.
//

import UIKit

extension UIViewController {
    
    func errorAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
