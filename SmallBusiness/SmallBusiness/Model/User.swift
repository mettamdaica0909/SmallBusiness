//
//  User.swift
//  SmallBusiness
//
//  Created by Duy Le on 8/27/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import Foundation

class User {
    var id: String?
    var email: String?
    var phoneNumber: String?
    var role: String?
    
    init(id: String, email: String, phoneNumber: String, role: String) {
        self.id = id
        self.email = email
        self.phoneNumber = phoneNumber
        self.role = role
    }
    
    func toAnyObject() -> [String : Any] {
        var jsonDict = [String : Any]()
        jsonDict["id"] = self.id
        jsonDict["email"] = self.email
        jsonDict["phoneNumber"] = self.phoneNumber
        jsonDict["role"] = self.role
        return jsonDict
    }
}

extension User {
    convenience init?(snapshot: Snapshot) {
        let dict = snapshot.value as? NSDictionary
        
        guard let role = dict?["role"] as? String else {
            return nil
        }
        
        guard let email = dict?["email"] as? String else {
            return nil
        }
        
        /*guard let firstName = dict?["firstName"] as? String else {
         return nil
         }
         
         guard let lastName = dict?["lastName"] as? String else {
         return nil
         } */
        
        var phoneNumber = ""
        if let temp = dict?["phoneNumber"] as? String {
            phoneNumber = temp
        }
        
        let id = snapshot.key
        
        self.init(id: id, email: email, phoneNumber: phoneNumber, role: role)
    }
}
