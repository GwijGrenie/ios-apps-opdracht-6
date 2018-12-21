//
//  RegisterViewController.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {

    // MARK: Instance variables
    
    private lazy var authenticationService: AuthenticationService = FirebaseAuthenticationService()
    
    // MARK: IBOutlets
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldRepeatPassword: UITextField!
    
    @IBOutlet weak var datePickerBirthday: UIDatePicker!
    
    @IBOutlet weak var labelGeneralError: UILabel!
    
    // MARK: IBActions
    
    @IBAction func onTouchUpInsideRegister(_ sender: Any) {
        
        labelGeneralError.isHidden = true
        
        let registrationCredentials = RegistrationCredentials(name: textFieldName.text, email: textFieldEmail.text, password: textFieldPassword.text, repeatPassword: textFieldRepeatPassword.text, birthDate: datePickerBirthday.date)
        authenticationService.registerAsync(WithCredentials: registrationCredentials, onFinished: self)
    }
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelGeneralError.isHidden = true
    }
}

extension RegistrationViewController: RegistrationDelegate {
    
    // MARK: RegistrationDelegate implementation
    
    func onRegistrationEnded(member: Member?, localizedError: String?) {
        guard let member = member else {
            labelGeneralError.isHidden = false
            labelGeneralError.text = localizedError!
            return
        }
        
        (self.navigationController!.viewControllers[0] as! AuthenticationUIDelegate).onLoginAuthenticated(member: member)
    }
}
