//
//  ViewController.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet weak var labelGeneralError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onTouchUpInsideButtonLogin(_ sender: Any) {
        self.labelGeneralError.isHidden = true
        
        let loginCredentials = LoginCredentials(email: textFieldEmail.text, password: textFieldPassword.text)
        FirebaseAuthenticationService.login(withCredentials: loginCredentials, endedDelegate: self)
    }
}

extension LoginViewController: LoginDelegate {
    
    func onEnded(user: User?, error: String?) {
        if error != nil {
            self.labelGeneralError.isHidden = false
            self.labelGeneralError.text = error!
            return
        }
        
        print(user!.email)
    }
}
