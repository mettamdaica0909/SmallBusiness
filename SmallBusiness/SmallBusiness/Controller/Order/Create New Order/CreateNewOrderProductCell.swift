//
//  CreateNewOrderProductCell.swift
//  SmallBusiness
//
//  Created by Duy Le on 9/18/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit

typealias DidTouchedButton = (UIButton, Product) -> Void

class CreateNewOrderProductCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    
    var product: Product! {
        didSet {
            self.productName.text = self.product.name
            self.productPrice.text = self.product.price.toLongCurrencyString(isVND: true)
            // set image
            if let productAvatar = self.product.avatarURL, productAvatar != "" {
                self.avatar.sd_setImage(with: URL(string: productAvatar), completed: nil)
            }
        }
    }
    
    var orderProduct: OrderProduct? {
        didSet {
            if orderProduct?.quantity ?? 0 > 0 {
                self.setupButtons(hasOrder: true)
            } else {
                self.setupButtons(hasOrder: false)
            }
        }
    }
    var didTouchedButton: DidTouchedButton = {button, product in}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatar.layer.cornerRadius = 30
        self.lineView.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        let plustImage = UIImage(imageLiteralResourceName: "ic_edit")
        self.plusBtn.setImage(plustImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        self.plusBtn.tintColor = UIColor.red
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func addBtnPress(_ sender: UIButton) {
        self.didTouchedButton(sender, self.product)
    }
    
    @IBAction func plusBtnPress(_ sender: UIButton) {
        self.didTouchedButton(sender, self.product)
    }
    
    @IBAction func minusBtnPress(_ sender: UIButton) {
        self.didTouchedButton(sender, self.product)
    }
    
    func setupButtons(hasOrder : Bool) {
        self.addBtn.isHidden = hasOrder
        self.minusBtn.isHidden = !hasOrder
        self.plusBtn.isHidden = !hasOrder
        self.quantityLabel.isHidden = !hasOrder
        self.quantityLabel.text = String(describing: orderProduct?.quantity ?? 0)
    }
}

