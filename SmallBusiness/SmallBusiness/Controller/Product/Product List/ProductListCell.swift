//
//  ProductListCell.swift
//  SmallBusiness
//
//  Created by Duy Le on 8/29/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit

class ProductListCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.avatar.layer.cornerRadius = 30
    }
    
    var product: Product! {
        didSet {
            self.lbName.text = self.product.name
            self.lbPrice.text = self.product.price.toLongCurrencyString(isVND: true)
            // set image
            if let productAvatar = self.product.avatarURL, productAvatar != "" {
                self.avatar.sd_setImage(with: URL(string: productAvatar), completed: nil)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
