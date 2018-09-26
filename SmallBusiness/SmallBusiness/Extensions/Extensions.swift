//
//  Extensions.swift
//  SmallBusiness
//
//  Created by Duy Le on 8/27/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit

extension String {
    func strimSpaceAndReplaceSpace() -> String {
        let tempString = self.trimmingCharacters(in: .whitespaces)
        return tempString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func trimmed() -> String? {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UIStoryboard {
    class func home() -> UIStoryboard {
        return UIStoryboard(name: "Home", bundle: nil)
    }
    
    class func product() -> UIStoryboard {
        return UIStoryboard(name: "Product", bundle: nil)
    }
    
    class func order() -> UIStoryboard {
        return UIStoryboard(name: "Order", bundle: nil)
    }
    
    func vcID(identifier: String) -> UIViewController {
        return self.instantiateViewController(withIdentifier:identifier)
    }
}

extension Double {
    func toDecimalStringBySystemLocale() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let currency = formatter.string(from: self as NSNumber)!
        return currency
    }
    
    func toCurrencyString(isVND: Bool, isReverse: Bool = false) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if isVND == true {
            formatter.locale = Locale(identifier: "vi_VN")
        }
        else {
            formatter.locale = Locale(identifier: "en_US")
        }
        let currency = formatter.string(from: self as NSNumber)!
        if isVND {
            return currency + "đ"
        }
        return "$" + currency
    }
    
    func toLongCurrencyString(isVND: Bool) -> String {
        let formatter = NumberFormatter()
        if isVND {
            formatter.locale = Locale(identifier: "vi_VN")
        }
        else {
            formatter.locale = Locale(identifier: "en_US")
        }
        
        let vnd = self
        if vnd < 1000000000 { // 1.000.000.000
            formatter.numberStyle = .decimal
            if isVND {
                return formatter.string(from: vnd as NSNumber)! + "đ"
            }
            return "$" + formatter.string(from: vnd as NSNumber)!
        }
        else {
            formatter.numberStyle = .decimal
            if isVND {
                return formatter.string(from: vnd / 1000.0 / 1000.0 / 1000.0 as NSNumber)! + "Tỷ"
            }
            return "$" + formatter.string(from: vnd as NSNumber)!
        }
    }
    
    func toShortCurrencyString(isVND: Bool) -> String {
        let formatter = NumberFormatter()
        if isVND {
            formatter.locale = Locale(identifier: "vi_VN")
        }
        else {
            formatter.locale = Locale(identifier: "en_US")
        }
        
        let vnd = self / 1000
        if vnd < 1000 {
            if isVND {
                return formatter.string(from: vnd as NSNumber)! + "K"
            }
            return "$" + formatter.string(from: vnd as NSNumber)!
        }
        else if vnd < 1000000 {
            formatter.numberStyle = .decimal
            if isVND {
                return formatter.string(from: vnd / 1000.0 as NSNumber)! + "Tr"
            }
            return "$" + formatter.string(from: vnd as NSNumber)!
        }
        else {
            formatter.numberStyle = .decimal
            if isVND {
                return formatter.string(from: vnd / 1000.0 / 1000.0 as NSNumber)! + "Tỷ"
            }
            return "$" + formatter.string(from: vnd as NSNumber)!
        }
    }
}
