//
//  Color+Extension.swift
//  MyWallet
//
//  Created by nang saw on 18/02/2021.
//

import UIKit

extension UIColor {
    static var myAppColor: UIColor {
        return UIColor(red: 255/255, green: 191/255, blue: 36/255, alpha: 1.0)
    }
    
    static var myAppRed: UIColor {
        return UIColor(red: 1, green: 0.1, blue: 0.1, alpha: 1)
    }
    static var myAppGreen: UIColor {
        return UIColor(red: 10/255, green: 105/255, blue: 68/255, alpha: 1)
    }
    static var myAppBlue: UIColor {
        return UIColor(red: 0, green: 0.2, blue: 0.9, alpha: 1)
    }
    static var myAppLightGreen: UIColor {
        return UIColor(red: 0.880, green: 1.000, blue: 0.892, alpha: 1.0)
    }
    static var myAppLightOrange: UIColor {
        return UIColor(red: 1.000, green: 0.924, blue: 0.804, alpha: 1.0)
    }

    static var myAppBlack: UIColor {
        return .black
    }

}

extension UIFont {
    static var myAppTitle: UIFont {
        return UIFont.systemFont(ofSize: 17)
    }
    static var myAppSubtitle: UIFont {
        return UIFont.systemFont(ofSize: 15)
    }
    static var myAppBody: UIFont {
        return UIFont.systemFont(ofSize: 14)
    }
}
