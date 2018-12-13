//
//  Converter.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation
import Firebase

protocol DataExtractor {
    
    associatedtype T
    
    func extractElement(_ documentSnapshot: DocumentSnapshot) -> T?
}
