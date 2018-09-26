//
//  Order.swift
//  SmallBusiness
//
//  Created by Duy Le on 8/28/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import Foundation

class Order {
    var id: String?
    var date: String?
    var shipper: String?
    var shipFee: String?
    var customerName: String?
    var customerPhone: String?
    var customerAddress: String?
    var status: String?
    var note: String?
    var shipperNote: String?
    var products = [Int : OrderProduct]()
    
    var totalPrice: Double {
        var totalPrice: Double = 0
        for product in self.products.values {
            totalPrice += product.totalPrice
        }
        return totalPrice
    }
    
    init(id: String, date: String) {
        self.id = id
        self.date = date
    }
}

