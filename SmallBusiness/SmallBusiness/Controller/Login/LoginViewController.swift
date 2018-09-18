import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    //--------------------------------------
    // MARK: - Properties
    //--------------------------------------
    let nc = NotificationCenter.default
    var textFields: [UITextField]!
    
    //--------------------------------------
    // MARK: - IBOutlets
    //--------------------------------------
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Small Business"
        self.loadingView.layer.cornerRadius = 15
        textFields = [emailTextField, passwordTextField]
        
        if let email = UserDefaults.standard.string(forKey: "email"),
            let password = UserDefaults.standard.string(forKey: "password") {
            progressBarDisplayer(msg: "Logging In")
            ConnectionManager.shared.loginUser(email: email, password: password, completion: { (object, error) in
                if error == nil {
                    DispatchQueue.main.async() {
                        self.loadingView.isHidden = true
                        self.progressBarDisplayer(msg: "Loading Data")
                    }
                } else {
                    self.presentLoginErrorAlert()
                    self.loadingView.isHidden = true
                }
            })
        }
        
        nc.addObserver(self,
                       selector: #selector(segueAfterInitialLoadComplete),
                       name: NSNotification.Name(rawValue: "LoginSuccess"),
                       object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.loadingView.isHidden = true
    }
    
    @objc func segueAfterInitialLoadComplete() {
        DispatchQueue.main.async() {
            self.loadingView.isHidden = true
            if let id = Auth.auth().currentUser?.uid {
                if let currentUser = ConnectionManager.shared.users[id] {
                    if currentUser.role == "Shop Owner" {
                        AppDelegate.shared.window?.rootViewController = MainTabController()
                    } else {
                        AppDelegate.shared.window?.rootViewController = UIStoryboard.home().vcID(identifier: "ShipperHomeVC")
                    }
                }
            }
        }
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        guard let password = passwordTextField.text,
            let email = emailTextField.text, allFieldsFilledOut()
            else { return }
        
        self.progressBarDisplayer(msg: "Logging in")
        
        ConnectionManager.shared.loginUser(email: email, password: password, completion: { (object, error) in
            if error == nil {
                DispatchQueue.main.async() {
                    self.loadingView.isHidden = true
                    self.progressBarDisplayer(msg: "Loading Data")
                }
            } else {
                self.presentLoginErrorAlert()
                self.loadingView.isHidden = true
            }
        })
    }

    func presentLoginErrorAlert() {
        let alert = UIAlertController(title: "Login Error",
                                      message: "",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Please try again.", style: .cancel, handler: { (action) in
            for textField in self.textFields {
                textField.text = ""
            }
        })
        
        alert.addAction(action)
        
        DispatchQueue.main.async() {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

private extension LoginViewController {
    func allFieldsFilledOut() -> Bool {
        for textField in textFields {
            if textField.text!.isEmpty {
                return false
            }
        }
        return true
    }
    
    func progressBarDisplayer(msg: String) {
        self.loadingView.isHidden = false
        self.loadingLabel.text = msg
    }
}

