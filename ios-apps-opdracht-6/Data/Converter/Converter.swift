//
//  Converter.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation

protocol Converter {
    associatedtype T
    
    func convert(_ data: [String: Any]) -> (result: T, error: String?)
}
