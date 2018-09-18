//
//  RegisterVC.swift
//  SmallBusiness
//
//  Created by Duy Le on 8/27/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    
    @IBOutlet weak var shopOwnerCheckMark: UIImageView!
    @IBOutlet weak var shipperCheckMark: UIImageView!
    
    let nc = NotificationCenter.default
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    var role = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nc.addObserver(self, selector: #selector(segueAfterAccountSignUpComplete), name: NSNotification.Name(rawValue: "LoginSuccess"), object: nil)
        self.title = "Sign Up"
    }
    
    @objc func segueAfterAccountSignUpComplete() {
        DispatchQueue.main.async() {
            self.messageFrame.removeFromSuperview()
            if let id = Auth.auth().currentUser?.uid {
                if let currentUser = ConnectionManager.shared.users[id] {
                    if currentUser.role == "Shop Owner" {
                        AppDelegate.shared.window?.rootViewController = MainTabController()
                    } else {
                        AppDelegate.shared.window?.rootViewController = UIStoryboard.home().vcID(identifier: "ShipperHomeVC")
                    }
                }
            }
        }
    }
    
    func progressBarDisplayer(msg: String, indicator: Bool) {
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.white
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(red: 199.0 / 255, green: 31.0 / 255, blue: 91.0 / 255, alpha: 1.00).withAlphaComponent(0.7)
        
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }
    
    func presentErrorMakingUserAlert() {
        let alert = UIAlertController(title: "Error Creating User", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Please try again", style: .cancel, handler: { (action) in
            self.messageFrame.removeFromSuperview()
        })
        alert.addAction(action)
        DispatchQueue.main.async() {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func onShopOwnerAction(_ sender: Any) {
        self.role = "Shop Owner"
        self.shopOwnerCheckMark.image = #imageLiteral(resourceName: "ic_order_check")
        self.shipperCheckMark.image = #imageLiteral(resourceName: "ic_order_uncheck")
    }
    
    @IBAction func onShipperAction(_ sender: Any) {
        self.role = "Shipper"
        self.shipperCheckMark.image = #imageLiteral(resourceName: "ic_order_check")
        self.shopOwnerCheckMark.image = #imageLiteral(resourceName: "ic_order_uncheck")
    }
    
    @IBAction func singUp(_ sender: Any) {
        guard let email = self.emailTextField.text,
            let password = self.passwordTextField.text,
            let rePassword = self.rePasswordTextField.text,
            let phone = self.phoneTextField.text else {
                return
        }
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            AlertService.shared.showAlert(vc: self, title: "", message: "Please enter your email.")
            return
        }
        
        if phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            AlertService.shared.showAlert(vc: self, title: "", message: "Please enter your phone.")
            return
        }
        
        if password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            AlertService.shared.showAlert(vc: self, title: "", message: "Please enter your password.")
            return
        }
        
        if rePassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            AlertService.shared.showAlert(vc: self, title: "", message: "Please reEnter your password.")
            return
        }
        
        if email.isValidEmail() == false {
            AlertService.shared.showAlert(vc: self, title: "Invalid email", message: "Please enter correct email.")
            return
        }
        
        if password != rePassword {
            AlertService.shared.showAlert(vc: self, title: "", message: "Confirm password does not match.")
            return
        }
        
        if self.role == "" {
            AlertService.shared.showAlert(vc: self, title: "", message: "Please select your role.")
            return
        }
        
        let id = UUID().uuidString
        let user = User(id: id, email: email, phoneNumber: phone, role: self.role)
        self.view.endEditing(true)
        
        self.progressBarDisplayer(msg: "Signing Up", indicator: true)
        ConnectionManager.shared.createUser(user: user, password: password) { (object, error) in
            if error == nil {
                DispatchQueue.main.async() {
                    self.messageFrame.removeFromSuperview()
                    self.progressBarDisplayer(msg: "Logging in", indicator: true)
                    ConnectionManager.shared.loginUser(email: email, password: password, completion: { (object, error) in
                        if error == nil {
                            DispatchQueue.main.async() {
                                self.messageFrame.removeFromSuperview()
                                self.progressBarDisplayer(msg: "Loading Data", indicator: true)
                            }
                        } else {
                            self.messageFrame.removeFromSuperview()
                        }
                    })
                    
                }
            } else {
                self.presentErrorMakingUserAlert()
            }
        }
    }
}

