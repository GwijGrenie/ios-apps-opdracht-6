//
//  FirebaseAuthenticationService.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation
import Firebase

class FirebaseAuthenticationService: AuthenticationService {

    // MARK: Type aliases
    
    typealias ValidationResult = (isValid: Bool, error: String?)
    
    // MARK: Instance variables
    
    private lazy var memberFirestoreDAO: MemberFirestoreDAO = MemberFirestoreDAO()
    
    // MARK: Public functions
    
    func loginAsync(WithCredentials loginCredentials: LoginCredentials, onFinished delegate: LoginDelegate?) {
        let validationResult: ValidationResult = validateLoginCredentials(loginCredentials)
        
        if !validationResult.isValid {
            delegate?.onLoginEnded(member: nil, localizedError: validationResult.error!)
            return
        }
        
        Auth.auth().signIn(withEmail: loginCredentials.email!, password: loginCredentials.password!, completion: { (authenticationDataResult, error) in
            
            if error != nil {
                delegate?.onLoginEnded(member: nil, localizedError: error!.localizedDescription)
                return
            }
            
            self.memberFirestoreDAO.getAsync(WhereUID: authenticationDataResult!.user.uid, onFinished: { member, error in
                
                delegate?.onLoginEnded(member: member, localizedError: error)
            })
        })
    }
    
    func registerAsync(WithCredentials registrationCredentials: RegistrationCredentials, onFinished delegate: RegistrationDelegate?) {
        let validationResult: ValidationResult = validateRegistrationCredentials(registrationCredentials)
        if !validationResult.isValid {
            delegate?.onRegistrationEnded(member: nil, localizedError: validationResult.error!)
            return
        }
        
        Auth.auth().createUser(withEmail: registrationCredentials.email!, password: registrationCredentials.password!) { (authenticationDataResult, error) in
            
            if error != nil {
                delegate?.onRegistrationEnded(member: nil, localizedError: error!.localizedDescription)
                return
            }
            
            let user = authenticationDataResult!.user
            
            let member = Member(id: String(), name: registrationCredentials.name!, birthday: registrationCredentials.birthDate, uid: user.uid)
            self.memberFirestoreDAO.createAsync(member, onFinished: {error in
                
                if error != nil {
                    print(error!)
                }
                
                self.memberFirestoreDAO.getAsync(WhereUID: user.uid, onFinished: { member, error in
                    delegate?.onRegistrationEnded(member: member, localizedError: error)
                })
            })
        }
    }
    
    // MARK: Local helpers
    
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
