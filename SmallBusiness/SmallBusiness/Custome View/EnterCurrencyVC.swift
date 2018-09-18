//
//  EnterCurrencyVC.swift
//  O-Mart
//
//  Created by Ninh Vo on 1/19/18.
//  Copyright © 2018 Ô Chợ Việt. All rights reserved.
//

import UIKit
//import Alamofire

class EnterCurrencyVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var txtContent: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    
    var didSaveBlock: ((Any) -> Void)?
    var product: Product!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        self.txtContent.delegate = self
        self.txtContent.placeholder = "Giá sản phẩm"
        let updateStr = "Đổi"
        self.lbTitle.text = "\(updateStr) \(self.txtContent.placeholder!.lowercased())"
        self.txtContent.text = product.price
        btnSave.setTitle("Lưu", for: .normal)
        btnCancel.setTitle("Hủy", for: .normal)
        self.txtContent.becomeFirstResponder()
    }
    
    func saveItem() {
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
        product.price = priceStr
        self.didSaveBlock?(self.product)
        self.dismiss(animated: true, completion: nil)
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
