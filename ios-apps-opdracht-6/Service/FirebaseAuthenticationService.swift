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
    let birthDate: Date?
}

class FirebaseAuthenticationService {
    
    private init() {}
    
    typealias ValidationResult = (isValid: Bool, error: String?)
    
    static func login(withCredentials loginCredentials: LoginCredentials, endedDelegate delegate: LoginDelegate?) {
        let validationResult: ValidationResult = validateLoginCredentials(loginCredentials)
        
        if !validationResult.isValid {
            delegate?.onEnded(user: nil, error: validationResult.error!)
            return
        }
        
        Auth.auth().signIn(withEmail: loginCredentials.email!, password: loginCredentials.password!, completion: { (authenticationDataResult, error) in
            
            if error != nil {
                delegate?.onEnded(user: nil, error: error!.localizedDescription)
                return
            }
            
            delegate?.onEnded(user: authenticationDataResult!.user, error: nil)
        })
        
    }
    
    static func register(withCredentials registrationCredentials: RegistrationCredentials, endedDelegate delegate: RegistrationDelegate?) {
        let validationResult: ValidationResult = validateRegistrationCredentials(registrationCredentials)
        if !validationResult.isValid {
            delegate?.onEnded(user: nil, error: validationResult.error!)
            return
        }
        
        // TODO: Call Firebase API to register user
    }
    
    private static func validateLoginCredentials(_ loginCredentials: LoginCredentials) -> ValidationResult {
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
    
    private static func validateRegistrationCredentials(_ registrationCredentials: RegistrationCredentials) -> ValidationResult {
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
        
        return (true, nil)
    }
}
