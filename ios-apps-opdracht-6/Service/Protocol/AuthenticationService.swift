//
//  AuthenticationService.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation

protocol AuthenticationService {
    
    func loginAsync(WithCredentials loginCredentials: LoginCredentials, onFinished delegate: LoginDelegate?)
    
    func registerAsync(WithCredentials registrationCredentials: RegistrationCredentials, onFinished delegate: RegistrationDelegate?)
}
