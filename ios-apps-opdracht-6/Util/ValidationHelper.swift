//
//  ValidationHelper.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation

class ValidationHelper {
    
    private init() {}
    
    typealias ValidationResult = (isValid: Bool, error: String?)
    
    static func validateRequiredText(_ text: String?, withLabel label: String) -> ValidationResult {
        guard let text = text else {
            return (false, label.capitalized + " cannot be empty")
        }
        
        if text.isEmpty {
            return (false, label.capitalized + " cannot be empty")
        }
        
        return (true, nil)
    }
    
    static func validatePasswords(password: String?, repeatPassword: String?, withLabel label: String) -> ValidationResult {
        guard let password = password, let repeatPassword = repeatPassword else {
            return (false, label.capitalized + " cannot be empty")
        }
        
        if password.isEmpty || repeatPassword.isEmpty {
            return (false, label.capitalized + " cannot be empty")
        }
        
        if password != repeatPassword {
            return (false, label.capitalized + " do not match")
        }
        
        return (true, nil)
    }
    
    static func validateBirthday(birthday: Date, minimumIncludedAge: Int, withLabel label: String) -> ValidationResult {
        let ageComponents = Calendar.current.dateComponents([.year], from: birthday, to: Date())
        let age = ageComponents.year!
        
        if age <= minimumIncludedAge {
            return (false, "Minimum age is " + String(minimumIncludedAge))
        }
        
        return (true, nil)
    }
}
