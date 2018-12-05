//
//  FirebaseAuthenticationService.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation
import Firebase

protocol LoginDelegate {
    func onEnded(user: User, error: String)
}

class FirebaseAuthenticationService {
    
    static func login(withEmail email: String, withPassword password: String, endedDelegate delegate: LoginDelegate?) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if let error = error {
            }
        })
        
    }
    
}
