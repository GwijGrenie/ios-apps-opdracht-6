//
//  ViewController.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: Instance variables
    
    private lazy var authenticationService: AuthenticationService = FirebaseAuthenticationService()
    
    // MARK: IBOutlets
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet weak var labelGeneralError: UILabel!
    
    // MARK: IBActions
    
    @IBAction func onTouchUpInsideButtonLogin(_ sender: Any) {
        self.labelGeneralError.isHidden = true
        let loginCredentials: LoginCredentials = LoginCredentials(email: textFieldEmail.text, password: textFieldPassword.text)
        authenticationService.loginAsync(WithCredentials: loginCredentials, onFinished: self)
    }
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LoginViewController: LoginDelegate {
    
    // MARK: LoginDelegate implementation
    
    func onLoginEnded(member: Member?, localizedError: String?) {
        
        guard let member = member else {
            self.labelGeneralError.isHidden = false
            self.labelGeneralError.text = localizedError!
            return
        }
        
        (self.navigationController!.viewControllers[0] as! AuthenticationUIDelegate).onLoginAuthenticated(member: member)
    }
}
