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
        
        let email = textFieldEmail.text!
        let password = textFieldPassword.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                self.labelGeneralError.isHidden = false
                self.labelGeneralError.text = error.localizedDescription
                return
            }
            
            print("---- Login Worked")
        }
    }
}
