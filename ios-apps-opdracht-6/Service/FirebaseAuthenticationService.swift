//
//  FirebaseAuthenticationService.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation
import Firebase

struct LoginCredentials {
    let email: String?
    let password: String?
}

struct RegistrationCredentials {
    let name: String?
    let email: String?
    let password: String?
    let repeatPassword: String?
    let birthDate: Date
}

class FirebaseAuthenticationService {
    
    typealias ValidationResult = (isValid: Bool, error: String?)
    
    private lazy var memberFirestoreDAO: MemberFirestoreDAO = MemberFirestoreDAO()
    
    init() {}
    
    func login(withCredentials loginCredentials: LoginCredentials, endedDelegate delegate: LoginDelegate?) {
        let validationResult: ValidationResult = validateLoginCredentials(loginCredentials)
        
        if !validationResult.isValid {
            delegate?.onEnded(member: nil, error: validationResult.error!)
            return
        }
        
        Auth.auth().signIn(withEmail: loginCredentials.email!, password: loginCredentials.password!, completion: { (authenticationDataResult, error) in
            
            if error != nil {
                delegate?.onEnded(member: nil, error: error!.localizedDescription)
                return
            }
            
            self.memberFirestoreDAO.getAsync(WhereUID: authenticationDataResult!.user.uid, onFinished: { member, error in
                
                delegate?.onEnded(member: member, error: error)
            })
        })
    }
    
    func register(withCredentials registrationCredentials: RegistrationCredentials, endedDelegate delegate: RegistrationDelegate?) {
        let validationResult: ValidationResult = validateRegistrationCredentials(registrationCredentials)
        if !validationResult.isValid {
            delegate?.onEnded(member: nil, error: validationResult.error!)
            return
        }
        
        Auth.auth().createUser(withEmail: registrationCredentials.email!, password: registrationCredentials.password!) { (authenticationDataResult, error) in
            
            if error != nil {
                delegate?.onEnded(member: nil, error: error!.localizedDescription)
                return
            }
            
            let user = authenticationDataResult!.user
            
            let member = Member(id: String(), name: registrationCredentials.name!, birthday: registrationCredentials.birthDate, uid: user.uid)
            self.memberFirestoreDAO.createAsync(member, onFinished: {error in
                print("Error adding extra credentials " + error!)
                
                self.memberFirestoreDAO.getAsync(WhereUID: user.uid, onFinished: { member, error in
                    delegate?.onEnded(member: member, error: error)
                })
            })
        }
    }
    
    private func validateLoginCredentials(_ loginCredentials: LoginCredentials) -> ValidationResult {
        let emailValidationResult = ValidationHelper.validateRequiredText(loginCredentials.email, withLabel: "email")
        if !emailValidationResult.isValid {
            return (false, emailValidationResult.error!)
        }
        
        let passwordValidationResult = ValidationHelper.validateRequiredText(loginCredentials.password, withLabel: "password")
        if !passwordValidationResult.isValid {
            return (false, passwordValidationResult.error!)
        }
        
        return (true, nil)
    }
    
    private func validateRegistrationCredentials(_ registrationCredentials: RegistrationCredentials) -> ValidationResult {
        let nameValidationResult = ValidationHelper.validateRequiredText(registrationCredentials.name, withLabel: "name")
        if !nameValidationResult.isValid {
            return (false, nameValidationResult.error!)
        }
        
        let emailValidationResult = ValidationHelper.validateRequiredText(registrationCredentials.email, withLabel: "email")
        if !emailValidationResult.isValid {
            return (false, emailValidationResult.error!)
        }
        
        let passwordValidationResult = ValidationHelper.validatePasswords(password: registrationCredentials.password, repeatPassword: registrationCredentials.repeatPassword, withLabel: "passwords")
        if !passwordValidationResult.isValid {
            return (false, passwordValidationResult.error!)
        }
        
        let birthdayValidationResult = ValidationHelper.validateBirthday(birthday: registrationCredentials.birthDate, minimumIncludedAge: 18, withLabel: "birthday")
        if !birthdayValidationResult.isValid {
            return (false, birthdayValidationResult.error!)
        }
        
        return (true, nil)
    }
}
