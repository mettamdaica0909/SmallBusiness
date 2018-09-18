//
//  Utils.swift
//  SmallBusiness
//
//  Created by Duy Le on 9/15/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

let USER_DEFAULTS = UserDefaults.standard
let NOTIFICATION_CENTER = NotificationCenter.default
let currentUser = Auth.auth().currentUser
let usersRef = Database.database().reference(withPath: "users")
let productsRef = Database.database().reference(withPath: "products")
let productPhotosRef = rootRefStorage.child("Product Pictures")

var rootRefDatabase = Database.database().reference()
var rootRefStorage = Storage.storage().reference()

func runAfterDelay(_ delay: Double, closure:@escaping () -> ()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
