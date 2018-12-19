//
//  Member.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation
import Firebase

struct Member {
    let id: String
    let name: String
    let birthday: Date
    let uid: String
}

extension Member: FirestoreExtractable {
    
    init(_ documentSnapshot: DocumentSnapshot) {
        id = documentSnapshot.documentID
        
        guard let data: [String: Any] = documentSnapshot.data() else {
            name = String()
            birthday = Date()
            uid = String()
            return
        }
        
        name = data["date"] as! String
        birthday = (data["birthday"] as! Timestamp).dateValue()
        uid = data["uid"] as! String
    }
}

extension Member: FirestoreStoreable {
    
    func getData() -> [String : Any] {
        return ["name": self.name, "birthday": self.birthday, "uid": self.uid]
    }
}
