//
//  ProductListVC.swift
//  SmallBusiness
//
//  Created by Duy Le on 8/29/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit
import Firebase

class ProductListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ProductListCell", bundle: Bundle.main), forCellReuseIdentifier: "ProductListCell")
        let rightBtn = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addProduct))
        self.navigationItem.rightBarButtonItem = rightBtn
        self.title = "Producs"
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGesture:)))
        longPressGesture.minimumPressDuration = 0.5 // 1 second press
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.products = ConnectionManager.shared.getProductListWithUserID(userID: (currentUser?.uid)!)
        self.emptyView.isHidden = self.products.count > 0
        self.tableView.reloadData()
    }
    
    @objc func handleLongPress(longPressGesture:UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: p) {
            if longPressGesture.state == UIGestureRecognizerState.began {
                let alert = UIAlertController(title: "",
                                              message: nil,
                                              preferredStyle: UIAlertControllerStyle.actionSheet)
                let delete = UIAlertAction(title: "Delete Product", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
                    let product = self.products[indexPath.row]
                    if let productID = product.id {
                        productsRef.child(productID).removeValue(completionBlock: { (error, ref) in
                            self.products = ConnectionManager.shared.getProductListWithUserID(userID: (currentUser?.uid)!)
                            self.tableView.reloadData()
                            if error != nil {
                                AlertService.shared.showAlert(vc: self, title: "", message: "Delete product fail.")
                            } else {
                                // delete product photo
                                productPhotosRef.child(productID).child("\(productID).jpg").delete(completion: nil)
                            }
                        })
                    }
                })
                delete.setValue(UIColor.red, forKey: "titleTextColor")
                alert.addAction(delete)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView = self.view
                }
                
                self.navigationController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func addProduct() {
        let createProductVC = UIStoryboard.product().vcID(identifier: "CreateProductVC")
        self.navigationController?.pushViewController(createProductVC, animated: true)
    }
    
    // Tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListCell", for: indexPath) as! ProductListCell
        cell.product = self.products[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = self.products[indexPath.row].copy()
        guard let editProductVC = UIStoryboard.product().vcID(identifier: "EditProductVC") as? EditProductVC else { return }
        editProductVC.product = product
        self.navigationController?.pushViewController(editProductVC, animated: true)
    }
}
