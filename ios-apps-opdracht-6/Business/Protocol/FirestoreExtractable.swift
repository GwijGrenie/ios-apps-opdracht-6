//
//  Extractable.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation
import Firebase

protocol FirestoreExtractable {
    init(_ documentSnapshot: DocumentSnapshot)
}
