//
//  EnterCurrencyVC.swift
//  O-Mart
//
//  Created by Ninh Vo on 1/19/18.
//  Copyright © 2018 Ô Chợ Việt. All rights reserved.
//

import UIKit
//import Alamofire

enum CurrencyType {
    case none
    case productPrice(Product)
    case orderQuantity(String)
}

class EnterCurrencyVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var txtContent: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    
    var didSaveBlock: ((Any) -> Void)?
    var viewTitle = ""
    var content = ""
    var placeHolder = ""
    var currencyType: CurrencyType = .none {
        didSet {
            switch currencyType {
            case .productPrice(let product):
                self.viewTitle = "Đổi giá sản phẩm"
                self.placeHolder = "Giá sản phẩm"
                self.content = product.price.toLongCurrencyString(isVND: true)
                break
            case .orderQuantity(let defaultQuantity):
                self.viewTitle = "Số lượng sản phẩm"
                self.placeHolder = "Số lượng sản phẩm"
                self.content = defaultQuantity
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        self.txtContent.delegate = self
        self.lbTitle.text = self.viewTitle
        self.txtContent.placeholder = self.placeHolder
        self.txtContent.text = self.content
        btnSave.setTitle("Lưu", for: .normal)
        btnCancel.setTitle("Hủy", for: .normal)
        self.txtContent.becomeFirstResponder()
    }
    
    func saveItem() {
        switch currencyType {
        case .productPrice(let product):
            guard let priceStr = self.txtContent.text?.trimmed(), !priceStr.isEmpty else {
                let msg = "Bạn chưa nhập Giá sản phẩm"
                AlertService.shared.showAlert(vc: self, title: "", message: msg)
                return
            }
            guard let price = Double(priceStr) else {
                let msg = "Giá sản phẩm chưa đúng"
                AlertService.shared.showAlert(vc: self, title: "", message: msg)
                return
            }
            product.price = price
            self.didSaveBlock?(product)
            self.dismiss(animated: true, completion: nil)
            break
        case .orderQuantity(_):
            guard let quantityStr = self.txtContent.text?.trimmed(), !quantityStr.isEmpty else {
                let msg = "Bạn chưa nhập số lượng"
                AlertService.shared.showAlert(vc: self, title: "", message: msg)
                return
            }

            guard let quantity = Double(quantityStr) else {
                let msg = "Số lượng sản phẩm chưa đúng"
                AlertService.shared.showAlert(vc: self, title: "", message: msg)
                return
            }
            self.didSaveBlock?(quantity)
            self.dismiss(animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    @IBAction func onCancelAction(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSaveAction(_ sender: Any) {
        self.view.endEditing(true)        
        saveItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "." {
            if textField.text.isNilOrEmpty {
                return false
            }
            if let text = textField.text, text.contains(".") {
                return false
            }
        }
        if string == "," {
            if textField.text.isNilOrEmpty {
                return false
            }
            if let text = textField.text, text.contains(",") {
                return false
            }
        }
        return true
    }
}
