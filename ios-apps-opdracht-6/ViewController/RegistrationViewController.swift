//
//  RegisterViewController.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {

    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldRepeatPassword: UITextField!
    
    @IBOutlet weak var datePickerBirthday: UIDatePicker!
    
    @IBOutlet weak var labelGeneralError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelGeneralError.isHidden = true
    }
    
    @IBAction func onTouchUpInsideRegister(_ sender: Any) {
        
        labelGeneralError.isHidden = true
        
        let registrationCredentials = RegistrationCredentials(name: textFieldName.text, email: textFieldEmail.text, password: textFieldPassword.text, repeatPassword: textFieldRepeatPassword.text, birthDate: datePickerBirthday.date)
        
        let service = FirebaseAuthenticationService()
        service.register(withCredentials: registrationCredentials, endedDelegate: self)
    }
}

extension RegistrationViewController: RegistrationDelegate {
    
    func onEnded(member: Member?, error: String?) {
        if error != nil {
            labelGeneralError.text = error!
            labelGeneralError.isHidden = false
            return
        }
        
        (self.navigationController!.viewControllers[0] as! AuthenticationUIDelegate).onLoginAuthenticated(member: member!)
    }
}
