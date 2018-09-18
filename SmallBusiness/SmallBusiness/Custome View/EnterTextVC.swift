//
//  EnterTextVC.swift
//  O-Mart
//
//  Created by Ninh Vo on 1/19/18.
//  Copyright © 2018 Ô Chợ Việt. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
//import Alamofire

enum EditType {
    case none
    case productName(Product)
}

class EnterTextVC: UIViewController ,UITextViewDelegate {
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var txtContent: KMPlaceholderTextView!
    @IBOutlet weak var lbCaption: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var didSaveBlock: ((Any) -> Void)?
    var didCancelBlock: (() -> Void)?
    
    var placeholder = ""
    var content = ""
    
    var editType: EditType = .none {
        didSet {
            switch editType {
            case .productName(let product):
                placeholder = "Tên sản phẩm"
                content = product.name ?? ""
                break
            default:
                break
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtContent.delegate = self
        
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        
        self.txtContent.placeholder = placeholder
        self.txtContent.becomeFirstResponder()
        
        self.txtContent.text = content
        let updateStr = "Đổi"
        self.lbCaption.text = "\(updateStr) \(placeholder.lowercased())"
        
        btnSave.setTitle("Đồng ý", for: .normal)
        btnCancel.setTitle("Huỷ", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        setStatusBarBackgroundColor(color: statusBarColor)
    }
    
    func saveProductName(item: Product) {
        guard let name = self.txtContent.text?.trimmed(), !name.isEmpty else {
            let msg = "Bạn chưa nhập Tên sản phẩm"
            AlertService.shared.showAlert(vc: self, title: "", message: msg)
            return
        }
        item.name = name
        self.didSaveBlock?(item)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancelAction(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true) {
            self.didCancelBlock?()
        }
    }
    
    @IBAction func onSaveAction(_ sender: Any) {
        self.view.endEditing(true)
        
        switch editType {
        case .productName(let product):
            saveProductName(item: product)
            break
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        switch editType {
        case .productName(_):
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            if newText.count > 100 {
                let finalText = String(newText.prefix(100))
                textView.text = finalText
                return false
            }
            return true
        default:
            return true
        }
    }
}
