//
//  CreateOrderDetailVC.swift
//  SmallBusiness
//
//  Created by Duy Le on 9/18/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit

class CreateOrderDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var orderProducts: [String : OrderProduct]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "OrderSummaryHeaderCell", bundle: nil), forCellReuseIdentifier: "OrderSummaryHeaderCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 1000
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CreateOrderDetailVC: UITableViewDelegate, UITableViewDataSource {
    // Tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryHeaderCell", for: indexPath) as! OrderSummaryHeaderCell
//        let product = self.products[indexPath.row]
//        cell.product = product
//        cell.orderProduct = self.orderProducts[product.id!]
//        cell.didTouchedButton = { [weak self] (button, product) in
//            self?.handleCellBtnClick(button: button, product: product)
//        }
        return cell
    }
}
