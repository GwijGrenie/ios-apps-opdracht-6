//
//  RegistrationDelegate.swift
//  ios-apps-opdracht-6
//
//  Created by gebruiker on 21/12/2018.
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation

protocol RegistrationDelegate {
    
    func onRegistrationEnded(member: Member?, localizedError: String?)
}
