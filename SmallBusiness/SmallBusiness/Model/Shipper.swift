//
//  Shipper.swift
//  SmallBusiness
//
//  Created by Duy Le on 8/28/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import Foundation


class Shipper {
    var id: String?
    var name: String?
    var phoneNumber: String?
    
    init(id: String, name: String, phoneNumber: String) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
    }
    
    func toAnyObject() -> [String : Any] {
        var jsonDict = [String : Any]()
        jsonDict["id"] = self.id
        jsonDict["name"] = self.name
        jsonDict["phoneNumber"] = self.phoneNumber
        return jsonDict
    }
    
}
