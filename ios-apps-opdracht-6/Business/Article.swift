//
//  Article.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation
import Firebase

struct Article {
    let id: String
    let description: String
    let minimumBidValue: Double
    var bids: [Bid]
}

extension Article: FirestoreExtractable {
    
    init(_ documentSnapshot: DocumentSnapshot) {
        id = documentSnapshot.documentID
        bids = [Bid]()
        
        guard let data: [String: Any] = documentSnapshot.data() else {
            description = String()
            minimumBidValue = Double()
            return
        }
        
        description = data["description"] as! String
        minimumBidValue = data["minimumBidValue"] as! NSNumber as! Double
    }
}

extension Article: FirestoreStoreable {
    
    func getData() -> [String : Any] {
        return ["description": description, "minimumBidValue": minimumBidValue]
    }
}
