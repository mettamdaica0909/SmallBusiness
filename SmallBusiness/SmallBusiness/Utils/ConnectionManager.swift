import UIKit

import Firebase
import FirebaseAuth

typealias NetworkResult = (AnyObject?, Error?) -> Void
typealias JSON = [String: Any]

protocol Snapshot {
    var value: Any? { get }
    var key: String { get }
}

extension DataSnapshot: Snapshot { }
typealias DatabaseEvent = (DataSnapshot) -> ()

class ConnectionManager {
    static let shared = ConnectionManager()
    
    let rootRef = Database.database().reference()
    let usersRef = Database.database().reference(withPath: "users")
    let productsRef = Database.database().reference(withPath: "products")
    let storageRef = Storage.storage().reference()
    let nc = NotificationCenter.default
    
    var users = [String: User]()
    var products = [String: Product]()
    
    func setupOneTimeListener() {
        // observers of type .Value will get called last, after all other observers have fired.
        // this way we know the intial loading is done when this event is fired
        // per this guy: http://www.waltza.com/2015/07/24/flamingpants-firebase-rxswift-and-slacktextviewcontroller/
        
        rootRef.observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            print(#function)
            self.nc.post(name: NSNotification.Name(rawValue: "LoginSuccess"), object: nil)
        }
    }
    
}

extension ConnectionManager { // for user
    func changePassword(newPassword: String, completion: @escaping (_ error: Error?) -> ()) {
        Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
            completion(error)
        })
    }
    
    func resetPassword(email: String, completion: @escaping (_ error: Error?) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
    }
    
    func logoutUser(completion: NetworkResult) {
        try! Auth.auth().signOut()
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        completion(true as AnyObject, nil)
    }
    
    
    func loginUser(email: String, password: String, completion: @escaping NetworkResult) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (firebaseUser, error) in
            if error == nil {
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(password, forKey: "password")
                self.setupOneTimeListener()
                completion(firebaseUser, nil)
            } else {
                completion(nil, error)
            }
        })
    }
    
    func createUser(user: User, password: String, completion: @escaping NetworkResult) {
        Auth.auth().createUser(withEmail: user.email!, password: password, completion: { (firebaseUser, error) in
            if error == nil {
                guard let uid = firebaseUser?.user.uid else { return }
                let childRef = self.usersRef.child(uid)
                
                let newUser = User(id: uid,
                                   email: user.email ?? "",
                                   phoneNumber: user.phoneNumber ?? "",
                                   role: user.role ?? "")
                
                childRef.setValue(newUser.toAnyObject())
                // find a way to set the userManager.currentUser while first signing up...
                completion(newUser as AnyObject, nil)
            } else {
                completion(nil, error)
            }
        })
    }
    
    func setupUserListeners() {
        self.usersRef.observe(.childAdded) { (snapshot: DataSnapshot) in
            if let user = User(snapshot: snapshot) {
                self.users[user.id!] = user
            }
        }
        
        self.usersRef.observe(.childChanged) { (snapshot: DataSnapshot) in
            if let user = User(snapshot: snapshot) {
                self.users[user.id!] = user
            }
        }
        
        self.usersRef.observe(.childRemoved) { (snapshot: DataSnapshot) in
            if let user = User(snapshot: snapshot) {
                self.users.removeValue(forKey: user.id!)
            }
        }
    }
}

extension ConnectionManager { // for product
    func createProduct(product: Product, completion: @escaping NetworkResult) {
        let productRef = self.productsRef.child(product.id!)        
        productRef.setValue(product.toAnyObject()) { (error, ref) in
            completion(nil, error)
        }
    }
    
    func updateProduct(product: Product) {
        let productNameRef = self.productsRef.child(product.id!).child("name")
        let productPriceRef = self.productsRef.child(product.id!).child("price")
        let productAvatarRef = self.productsRef.child(product.id!).child("avatarURL")
        
        productNameRef.setValue(product.name)
        productPriceRef.setValue(product.price)
        productAvatarRef.setValue(product.avatarURL)
    }
    
    func getProductListWithUserID (userID: String) -> [Product] {
        var productList = [Product]()
        for product in self.products.values {
            if product.owner == userID {
                productList.append(product)
            }
        }
        return productList
    }
    
    func setupProductListeners() {
        self.productsRef.observe(.childAdded) { (snapshot: DataSnapshot) in
            if let product = Product(snapshot: snapshot) {
                self.products[product.id!] = product
            }
        }
        
        self.productsRef.observe(.childChanged) { (snapshot: DataSnapshot) in
            if let product = Product(snapshot: snapshot) {
                self.products[product.id!] = product
            }
        }
        
        self.productsRef.observe(.childRemoved) { (snapshot: DataSnapshot) in
            if let product = Product(snapshot: snapshot) {
                self.products.removeValue(forKey: product.id!)
            }
        }
    }

}

