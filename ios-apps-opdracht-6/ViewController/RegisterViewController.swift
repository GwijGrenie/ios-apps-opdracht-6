//
//  RegisterViewController.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldRepeatPassword: UITextField!
    
    @IBOutlet weak var labelErrorEmail: UILabel!
    @IBOutlet weak var labelErrorPassword: UILabel!
    
    @IBOutlet weak var datePickerBirth: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onTouchUpInsideRegister(_ sender: Any) {
        
        if !validateForm() {
            return
        }
        
        let email = textFieldEmail.text!
        let password = textFieldPassword.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                return
            }
            
            print("Test")
            print(user.email)
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RegisterViewController {
    
    func hideAllErrors() {
        labelErrorEmail.isHidden = true
        labelErrorPassword.isHidden = true
    }
    
    func showError(_ label: UILabel,_ textField: UITextField, _ text: String) {
        textField.setErrorAnimation(WithBaseColor: UIColor.red.cgColor, WithNumberOfShakes: 100, WithRevert: true)
        label.isHidden = false
        label.text = text
    }
    
    func validateForm() -> Bool {
        hideAllErrors()
        
        var isValid = true
        
        if !validateEmail() {
            isValid = false
        }
        
        
        return isValid
    }
    
    func validateEmail() -> Bool {
        guard let email = textFieldEmail.text else {
            showError(labelErrorEmail, textFieldEmail, "Email is required")
            return false
        }
        
        if email.isEmpty {
            showError(labelErrorEmail, textFieldEmail, "Email is required")
            return false
        }
        
        return true
    }
    
    func validatePassword() -> Bool {
        guard let password = textFieldPassword.text else {
            textFieldPassword.text = "Password is required"
            return false
        }
        
        return true
    }
}
