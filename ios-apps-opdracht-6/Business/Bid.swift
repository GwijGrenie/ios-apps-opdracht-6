//
//  Bid.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation
import Firebase

struct Bid {
    let id: String
    let value: Double
    let date: Date
    let memberId: String
}

extension Bid: FirestoreExtractable {
    
    init(_ documentSnapshot: DocumentSnapshot) {
        id = documentSnapshot.documentID
        
        guard let data: [String: Any] = documentSnapshot.data() else {
            value = Double()
            date = Date()
            memberId = String()
            return
        }
                
        let b:CFNumber = data["value"] as! CFNumber
        var bidFloat :Float = 0
        if CFNumberGetValue(b, CFNumberType.floatType,&bidFloat ) {
            value = Double(bidFloat)
        }
        else {
            value = 0
        }
        
        date = (data["date"] as! Timestamp).dateValue()
        memberId = data["memberId"] as! String
    }
}

extension Bid: FirestoreStoreable {
    
    func getData() -> [String : Any] {
        return ["value": value, "date": date, "memberId": memberId]
    }
}
