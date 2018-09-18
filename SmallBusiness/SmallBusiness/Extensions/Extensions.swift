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
    
    func vcID(identifier: String) -> UIViewController {
        return self.instantiateViewController(withIdentifier:identifier)
    }
}
