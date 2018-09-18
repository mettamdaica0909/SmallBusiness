//
//  AlertService.swift
//  DBPrototype
//
//  Created by Duy Le on 7/16/18.
//  Copyright © 2018 Arrested Dev. All rights reserved.
//

import Foundation
import UIKit

class AlertService {
    static let shared = AlertService()
    
    func showAlert(vc: UIViewController ,title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancel)
            vc.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAlertWithCompletion(vc: UIViewController, title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: handler)
            alertController.addAction(cancel)
            vc.present(alertController, animated: true, completion: nil)
        }
    }
}

