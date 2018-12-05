//
//  AuthenticationDelegate.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation
import Firebase

protocol LoginDelegate {
    func onEnded(user: User?, error: String?)
}

protocol RegistrationDelegate {
    func onEnded(user: User?, error: String?)
}
