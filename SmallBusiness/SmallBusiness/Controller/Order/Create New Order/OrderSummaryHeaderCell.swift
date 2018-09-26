//
//  OrderSummaryHeaderCell.swift
//  O-Mart
//
//  Created by Mettamdaica on 6/27/18.
//  Copyright © 2018 Ô Chợ Việt. All rights reserved.
//

import UIKit
typealias DidTouchedBtn = (UIButton) -> Void
class OrderSummaryHeaderCell: UITableViewCell {
    @IBOutlet weak var receiverBtn: UIButton!
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var phoneBtn: UIButton!
    
    @IBOutlet weak var receiverNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var editIcon1: UIImageView!    
    @IBOutlet weak var editIcon3: UIImageView!
    @IBOutlet weak var editIcon2: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var noteValue: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var lineView1: UIView!
    @IBOutlet weak var lineView2: UIView!
    @IBOutlet weak var lineView3: UIView!
    
    @IBOutlet weak var noteBtn: UIButton!
    
    @IBOutlet weak var receiverNameTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    
    var didTouchedButton: DidTouchedBtn = {button in}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lineView.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        self.lineView1.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        self.lineView2.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        self.lineView3.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        
        self.noteBtn.layer.borderWidth = 1
        self.noteBtn.layer.cornerRadius = 5
        self.noteBtn.layer.borderColor = UIColor.gray.cgColor //UIColor(color: .gray, alpha: 0.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func toAddressBtnPress(_ sender: UIButton) {
        self.didTouchedButton(sender)
    }
    @IBAction func toPersonBtnPress(_ sender: UIButton) {
        self.didTouchedButton(sender)
    }
    @IBAction func toPhoneBtnPress(_ sender: UIButton) {
        self.didTouchedButton(sender)
    }
    
    @IBAction func noteBtnPress(_ sender: UIButton) {
        self.didTouchedButton(sender)
    }
}
