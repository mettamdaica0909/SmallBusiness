//
//  Product.swift
//  SmallBusiness
//
//  Created by Duy Le on 8/28/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import Foundation

class Product {
    var id: String?
    var name: String?
    var price: String?
    var avatarURL: String?
    var owner: String?
    
    init(id: String, name: String, price: String, avatarURL: String, owner: String) {
        self.id = id
        self.name = name
        self.price = price
        self.avatarURL = avatarURL
        self.owner = owner
    }
    
    func toAnyObject() -> [String : Any] {
        var jsonDict = [String : Any]()
        jsonDict["id"] = self.id
        jsonDict["name"] = self.name
        jsonDict["price"] = self.price
        jsonDict["avatarURL"] = self.avatarURL
        jsonDict["owner"] = self.owner
        return jsonDict
    }
    
    func copy() -> Product {
        return Product(id: self.id!, name: self.name!, price: self.price!, avatarURL: self.avatarURL!, owner: self.owner!)
    }
}

extension Product {
    convenience init?(snapshot: Snapshot) {
        let dict = snapshot.value as? NSDictionary
        
        guard let id = dict?["id"] as? String else {
            return nil
        }
        
        guard let name = dict?["name"] as? String else {
            return nil
        }
        
        guard let price = dict?["price"] as? String else {
            return nil
        }
        
        guard let avatarURL = dict?["avatarURL"] as? String else {
            return nil
        }
        
        guard let owner = dict?["owner"] as? String else {
            return nil
        }
        
        self.init(id: id, name: name, price: price, avatarURL: avatarURL, owner: owner)
    }
}
