//
//  CreateNewOrderVC.swift
//  SmallBusiness
//
//  Created by Duy Le on 9/18/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit

class CreateNewOrderVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var orderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var createOrder: UIButton!
    @IBOutlet weak var orderLabel: UILabel!
    
    var products = [Product]()
    var orderProducts = [String : OrderProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CreateNewOrderProductCell", bundle: Bundle.main), forCellReuseIdentifier: "CreateNewOrderProductCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.products = ConnectionManager.shared.getProductListWithUserID(userID: (currentUser?.uid)!)
        self.emptyView.isHidden = self.products.count > 0
        self.showOrderView()
        self.tableView.reloadData()
    }
    
    @IBAction func onCreateNewOrderAction(_ sender: Any) {
        guard let createOrderDetailVC = UIStoryboard.order().vcID(identifier: "CreateOrderDetailVC") as? CreateOrderDetailVC else { return }
        createOrderDetailVC.orderProducts = self.orderProducts
        self.navigationController?.pushViewController(createOrderDetailVC, animated: true)
    }
}

extension CreateNewOrderVC: UITableViewDelegate, UITableViewDataSource {
    // Tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateNewOrderProductCell", for: indexPath) as! CreateNewOrderProductCell
        let product = self.products[indexPath.row]
        cell.product = product
        cell.orderProduct = self.orderProducts[product.id!]
        cell.didTouchedButton = { [weak self] (button, product) in
            self?.handleCellBtnClick(button: button, product: product)
        }
        return cell
    }
    
    func handleCellBtnClick(button : UIButton, product: Product) {
        // handle add button
        if button.tag == 1 {
            self.view.endEditing(true)
            
            let vc = EnterCurrencyVC()
            vc.currencyType = .orderQuantity("")
            
            vc.didSaveBlock = { [weak self] (quantity) in
                if let quantity = quantity as? Double {
                    let orderProduct = OrderProduct.init(id: product.id!, product: product, quantity: quantity)
                    self?.orderProducts[product.id!] = orderProduct
                    self?.tableView.reloadData()
                    self?.showOrderView(show: self?.orderProducts.count ?? 0 > 0)
                }
            }
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
        
        // handle delete button
        if button.tag == 2 {
            self.orderProducts.removeValue(forKey: product.id!)
        }
        
        // handle edit button
        if button.tag == 3 {
            self.view.endEditing(true)
            
            let vc = EnterCurrencyVC()
            vc.currencyType = .orderQuantity("\(String(describing: self.orderProducts[product.id!]?.quantity ?? 0))")
            
            vc.didSaveBlock = { [weak self] (quantity) in
                if let quantity = quantity as? Double {
                    self?.orderProducts[product.id!]?.quantity = quantity
                    self?.tableView.reloadData()
                    self?.showOrderView(show: self?.orderProducts.count ?? 0 > 0)
                }
            }
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
        
        self.tableView.reloadData()
        self.showOrderView(show: self.orderProducts.count > 0)
    }
    
    func showOrderView(show: Bool) {
        self.orderView.isHidden = !show
        if show == false {
            self.orderViewHeight.constant = 0
        }
        else {
            self.orderViewHeight.constant = 44
        }
        
        self.showOrderView()
        self.orderLabel.text = self.createOrderDetailStr()
        self.view.layoutIfNeeded()
    }
    
    func createOrderDetailStr() -> String {
        if self.orderProducts.count > 0 {
            var totalPrice: Double = 0
            for orderProduct in self.orderProducts.values {
                totalPrice += orderProduct.totalPrice
            }
            let sanpham = "Sản phẩm"

            return String.init(format: "%d %@ - %@", self.orderProducts.count, sanpham, totalPrice.toLongCurrencyString(isVND: true))
        }
        return ""
    }
    
    func showOrderView() {
        let show = self.orderProducts.count > 0
        self.orderView.isHidden = !show
        if show == false {
            self.orderViewHeight.constant = 0
        }
        else {
            self.orderViewHeight.constant = 44
        }
        self.view.layoutIfNeeded()
    }
}
