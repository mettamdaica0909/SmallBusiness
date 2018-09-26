//
//  OrderListVC.swift
//  SmallBusiness
//
//  Created by Duy Le on 8/28/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit

class OrderListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var orders = [Order]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.emptyView.isHidden = self.orders.count > 0
        self.tableView.reloadData()
    }
    
    @IBAction func onCreateNewOrderAction(_ sender: Any) {
        guard let createOrderVC = UIStoryboard.order().vcID(identifier: "CreateNewOrderVC") as? CreateNewOrderVC else { return }
        self.navigationController?.pushViewController(createOrderVC, animated: true)
    }
}

extension OrderListVC: UITableViewDataSource, UITableViewDelegate {
    // Tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListCell", for: indexPath) as! ProductListCell
//        cell.product = self.orders[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let product = self.orders[indexPath.row].copy()
//        guard let editProductVC = UIStoryboard.product().vcID(identifier: "EditProductVC") as? EditProductVC else { return }
//        editProductVC.product = product
//        self.navigationController?.pushViewController(editProductVC, animated: true)
    }
}
