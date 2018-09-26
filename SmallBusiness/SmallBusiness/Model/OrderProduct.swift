//
//  OrderProduct.swift
//  SmallBusiness
//
//  Created by Duy Le on 9/18/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import Foundation

class OrderProduct {
    var id: String?
    var product: Product?
    var quantity: Double = 0
    var totalPrice: Double {
        return ((self.product?.price ?? 0) * Double(self.quantity))
    }
    init(id: String, product: Product, quantity: Double) {
        self.id = id
        self.product = product
        self.quantity = quantity
    }
    
    func toAnyObject() -> [String : Any] {
        var jsonDict = [String : Any]()
        jsonDict["id"] = self.id
        jsonDict["quantity"] = self.quantity
        jsonDict["totalPrice"] = self.totalPrice
        return jsonDict
    }
}
