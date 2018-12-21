//
//  LoginDelegate.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation

protocol LoginDelegate {
    
    func onLoginEnded(member: Member?, localizedError: String?)
}
